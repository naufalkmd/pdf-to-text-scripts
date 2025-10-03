#!/usr/bin/env pwsh
# pdf2txt-lite.ps1
# Lightweight PDF text extraction without OCR (works without Ghostscript)

param(
    [string]$OutputDir = "read_pdf"
)

Write-Host "PDF2TXT Lite Text Extractor (No OCR)" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

# Function to check if a command exists
function Test-Command {
    param([string]$Command)
    $null = Get-Command $Command -ErrorAction SilentlyContinue
    return $?
}

# Check required commands
if (-not (Test-Command "pdftotext")) {
    Write-Error "Missing pdftotext. Please install poppler tools."
    exit 1
}

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    Write-Host "Created output directory: $OutputDir" -ForegroundColor Cyan
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
            Write-Host "Added read_pdf/ to .gitignore" -ForegroundColor Cyan
        }
    }
} catch {
    # Not in a git repository, ignore
}

# Find PDF files
$pdfFiles = Get-ChildItem -Path "." -Filter "*.pdf"
if ($pdfFiles.Count -eq 0) {
    Write-Host "No PDF files found in current directory" -ForegroundColor Yellow
    Write-Host "Copy some PDF files here and run the script again." -ForegroundColor Cyan
    exit 0
}

Write-Host "Found $($pdfFiles.Count) PDF file(s) to process:" -ForegroundColor Yellow
foreach ($pdf in $pdfFiles) {
    $sizeKB = [math]::Round($pdf.Length / 1KB, 1)
    Write-Host "  📄 $($pdf.Name) ($sizeKB KB)" -ForegroundColor White
}
Write-Host ""

$successCount = 0
$totalChars = 0

# Process each PDF
foreach ($pdf in $pdfFiles) {
    Write-Host "Processing: $($pdf.Name)" -ForegroundColor Yellow
    $baseName = $pdf.BaseName
    $safeName = $baseName -replace '\s+', '_'
    
    $outputFile = Join-Path $OutputDir "$safeName.txt"
    
    try {
        # Extract text using pdftotext
        pdftotext -layout -enc UTF-8 $pdf.FullName $outputFile
        
        if (Test-Path $outputFile) {
            $content = Get-Content $outputFile -Raw -Encoding UTF8
            if ($content) {
                # Clean up text and normalize line endings
                $content = $content -replace "`r`n", "`n" -replace "`r", "`n"
                # Split into paragraphs and rejoin with double newlines
                $paragraphs = ($content -split "`n`n+" | Where-Object { $_.Trim() -ne "" })
                $cleanContent = $paragraphs -join "`n`n"
                
                Set-Content -Path $outputFile -Value $cleanContent -Encoding UTF8
                
                $charCount = ($cleanContent -replace '\s', '').Length
                $totalChars += $charCount
                
                if ($charCount -gt 50) {
                    Write-Host "  ✅ Success: $charCount characters extracted" -ForegroundColor Green
                    Write-Host "     📁 Saved to: $outputFile" -ForegroundColor Cyan
                    $successCount++
                } else {
                    Write-Host "  ⚠️  Low text content ($charCount chars) - may be scanned image" -ForegroundColor Yellow
                    Write-Host "     💡 This PDF would benefit from OCR processing" -ForegroundColor Cyan
                    Write-Host "     📁 Saved to: $outputFile" -ForegroundColor Cyan
                }
            } else {
                Write-Host "  ⚠️  No text found - likely a scanned PDF requiring OCR" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  ❌ Failed to create output file" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ❌ Error processing $($pdf.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== Processing Complete ===" -ForegroundColor Green
Write-Host "Successfully processed: $successCount/$($pdfFiles.Count) files" -ForegroundColor White
Write-Host "Total characters extracted: $totalChars" -ForegroundColor White
Write-Host "Output directory: $OutputDir" -ForegroundColor Cyan

if ($successCount -lt $pdfFiles.Count) {
    Write-Host ""
    Write-Host "💡 To process scanned PDFs or improve text quality:" -ForegroundColor Yellow
    Write-Host "   1. Install Ghostscript: https://www.ghostscript.com/download/" -ForegroundColor Cyan
    Write-Host "   2. Use pdf2txt.ps1 or pdf2txt-lite.ps1 for OCR processing" -ForegroundColor Cyan
}