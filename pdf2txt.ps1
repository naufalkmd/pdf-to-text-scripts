#!/usr/bin/env pwsh
# pdf2txt.ps1
# Windows PowerShell version of pdf2txt
# OCR all PDFs in the current directory with enhanced processing

param(
    [string]$OutputDir = "read_pdf",
    [string]$Languages = "eng",
    [int]$DPI = 600,
    [int]$PageSegMode = 6,
    [int]$TesseractTimeout = 180
)

# Function to check if a command exists
function Test-Command {
    param([string]$Command)
    $null = Get-Command $Command -ErrorAction SilentlyContinue
    return $?
}

# Check required commands
$requiredCommands = @("pdftotext", "pdfinfo")
foreach ($cmd in $requiredCommands) {
    if (-not (Test-Command $cmd)) {
        Write-Error "Missing $cmd. Please install poppler tools."
        exit 1
    }
}

# Check for ocrmypdf
$ocrmypdfPath = "C:\Users\saga0\AppData\Roaming\Python\Python311\Scripts\ocrmypdf.exe"
if (-not (Test-Path $ocrmypdfPath)) {
    Write-Error "Missing ocrmypdf. Please install via: pip install ocrmypdf"
    exit 1
}

# Check for Ghostscript
$hasGhostscript = $false
try {
    # Try Windows-specific Ghostscript executables first
    if (Get-Command gswin64c -ErrorAction SilentlyContinue) {
        $hasGhostscript = $true
    } elseif (Get-Command gswin32c -ErrorAction SilentlyContinue) {
        $hasGhostscript = $true
    } elseif (Get-Command gs -ErrorAction SilentlyContinue) {
        $hasGhostscript = $true
    } else {
        throw "Ghostscript not found"
    }
} catch {
    Write-Host "⚠️  WARNING: Ghostscript not found!" -ForegroundColor Yellow
    Write-Host "   OCR processing will fail. For full functionality:" -ForegroundColor Yellow
    Write-Host "   1. Install Ghostscript: https://www.ghostscript.com/download/" -ForegroundColor Cyan
    Write-Host "   2. Or use pdf2txt-lite.bat for basic text extraction" -ForegroundColor Cyan
    Write-Host "" 
    
    # Ask user if they want to continue with basic extraction
    $continue = Read-Host "Continue with basic text extraction only? (y/N)"
    if ($continue -notlike "y*") {
        exit 1
    }
    Write-Host "Continuing with basic text extraction (no OCR)..." -ForegroundColor Green
    Write-Host ""
}

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Update .gitignore if in a git repository
try {
    git rev-parse --is-inside-work-tree 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $gitignoreContent = ""
        if (Test-Path ".gitignore") {
            $gitignoreContent = Get-Content ".gitignore" -Raw
        }
        if ($gitignoreContent -notmatch "read_pdf/") {
            Add-Content ".gitignore" "`nread_pdf/"
        }
    }
} catch {
    # Not in a git repository, ignore
}

# Create temporary directory
$tempDir = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }

try {
    # Find PDF files
    $pdfFiles = Get-ChildItem -Path "." -Filter "*.pdf"
    if ($pdfFiles.Count -eq 0) {
        Write-Host "No PDF files found in current directory"
        exit 0
    }

    # Sort PDFs by complexity heuristic (pages * file size)
    $workList = @()
    foreach ($pdf in $pdfFiles) {
        try {
            $pdfInfoOutput = pdfinfo $pdf.FullName 2>$null
            $pages = 1
            if ($pdfInfoOutput) {
                $pagesLine = $pdfInfoOutput | Select-String "Pages:\s*(\d+)"
                if ($pagesLine) {
                    $pages = [int]$pagesLine.Matches[0].Groups[1].Value
                }
            }
            $size = $pdf.Length
            $cost = $pages * ($size / 1024 + 1)
            $workList += @{ Cost = $cost; File = $pdf }
        } catch {
            $workList += @{ Cost = $pdf.Length; File = $pdf }
        }
    }
    
    # Sort by cost (easiest first)
    $sortedFiles = $workList | Sort-Object Cost | ForEach-Object { $_.File }

    # Process each PDF
    foreach ($pdf in $sortedFiles) {
        Write-Host "Processing: $($pdf.Name)"
        $baseName = $pdf.BaseName
        $safeName = $baseName -replace '\s+', '_'
        
        $outputFile = Join-Path $OutputDir "$safeName.txt"
        
        if ($hasGhostscript) {
            # Full OCR processing with Ghostscript
            $ocrPdf = Join-Path $tempDir "$safeName`_ocr.pdf"
            $txtTemp = Join-Path $tempDir "$safeName.txt"
            
            $ocrmypdfArgs = @(
                "--force-ocr"
                "--rotate-pages"
                "--deskew"
                "--image-dpi", $DPI
                "--language", $Languages
                "--tesseract-timeout", $TesseractTimeout
                "--tesseract-pagesegmode", $PageSegMode
                "--quiet"
                $pdf.FullName
                $ocrPdf
            )
            
            & $ocrmypdfPath @ocrmypdfArgs
            if ($LASTEXITCODE -ne 0) {
                Write-Warning "  ocrmypdf failed on $($pdf.Name), trying basic extraction..."
                # Fallback to basic extraction
                pdftotext -layout -enc UTF-8 $pdf.FullName $outputFile
            } else {
                # Extract text from OCR'd PDF
                pdftotext -q -layout -enc UTF-8 $ocrPdf $txtTemp
                if (Test-Path $txtTemp) {
                    $textContent = Get-Content $txtTemp -Raw -Encoding UTF8
                    
                    # Check if we got enough text, retry with higher DPI if needed
                    $charCount = ($textContent -replace '\s', '').Length
                    if ($charCount -lt 50) {
                        Write-Host "  Low text detected — retrying at DPI=700"
                        $retryArgs = $ocrmypdfArgs.Clone()
                        $retryArgs[5] = "700"  # Update DPI value
                        
                        & $ocrmypdfPath @retryArgs
                        if ($LASTEXITCODE -eq 0) {
                            pdftotext -q -layout -enc UTF-8 $ocrPdf $txtTemp
                            if (Test-Path $txtTemp) {
                                $textContent = Get-Content $txtTemp -Raw -Encoding UTF8
                            }
                        }
                    }
                } else {
                    Write-Warning "  pdftotext failed on OCR'd PDF, trying basic extraction..."
                    pdftotext -layout -enc UTF-8 $pdf.FullName $outputFile
                    continue
                }
            }
        } else {
            # Basic text extraction (no OCR)
            Write-Host "  Using basic text extraction (no OCR)"
            pdftotext -layout -enc UTF-8 $pdf.FullName $outputFile
            if (Test-Path $outputFile) {
                $textContent = Get-Content $outputFile -Raw -Encoding UTF8
            }
        }
        
        # Clean up text and save to output directory (common for both OCR and basic)
        if ($textContent) {
            # Remove carriage returns and normalize line endings
            $textContent = $textContent -replace "`r`n", "`n" -replace "`r", "`n"
            # Split into paragraphs and rejoin with double newlines
            $paragraphs = ($textContent -split "`n`n+" | Where-Object { $_.Trim() -ne "" })
            $cleanContent = $paragraphs -join "`n`n"
            
            Set-Content -Path $outputFile -Value $cleanContent -Encoding UTF8
            
            $charCount = ($cleanContent -replace '\s', '').Length
            if ($hasGhostscript) {
                Write-Host "  ✅ OCR Success: $charCount characters extracted" -ForegroundColor Green
            } else {
                Write-Host "  ✅ Basic extraction: $charCount characters" -ForegroundColor Green
            }
            Write-Host "     📁 Saved to: $outputFile" -ForegroundColor Cyan
        } else {
            Write-Host "  ❌ No text extracted" -ForegroundColor Red
        }
    }
    
    Write-Host "Done. Output files in: $OutputDir"
    
} finally {
    # Cleanup temporary directory
    if (Test-Path $tempDir) {
        Remove-Item $tempDir -Recurse -Force
    }
}