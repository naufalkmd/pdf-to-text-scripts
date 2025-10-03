# PDF2TXT Converter - Complete Windows Setup Guide

This comprehensive guide will help you set up the PDF2TXT converter on Windows with full OCR capabilities.

## 📋 Overview

The PDF2TXT converter provides two modes:

- **Full OCR Mode** (`pdf2txt.bat`) - Advanced processing with OCR for scanned documents
- **Basic Mode** (`pdf2txt-lite.bat`) - Quick text extraction from PDFs with existing text

## 🚀 Quick Start (5 Minutes)

### Step 1: Install Ghostscript

1. **Download**: Go to [Ghostscript Releases](https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/)
2. **Find**: Look for `gs10060w64.exe` (Windows 64-bit installer)
3. **Install**: Run as Administrator, use default location (`C:\Program Files\gs\`)
4. **Verify**: Restart terminal, test with `gswin64c --version`

### Step 2: Install Python Dependencies

```powershell
pip install ocrmypdf
```

### Step 3: Test Your Setup

```cmd
REM Basic text extraction (should work immediately)
pdf2txt-lite.bat

REM Full OCR processing (requires Ghostscript)
pdf2txt.bat
```

## 🔧 Detailed Installation Guide

### Prerequisites Check

Run these commands to verify your system:

```powershell
# Check Python
python --version

# Check if Tesseract is installed
tesseract --version

# Check if poppler tools are available
pdftotext -v

# Check if OCRmyPDF is installed
pip show ocrmypdf

# Check Ghostscript (after installation)
gswin64c --version
```

### Installing Ghostscript (Critical Component)

#### Method 1: Official Installer (Recommended)

1. **Navigate to**: https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/
2. **Download**: `gs10060w64.exe` (or latest Windows 64-bit version)
3. **Install**:
   - Right-click installer → "Run as administrator"
   - Accept license (GPL/AGPL)
   - Install to: `C:\Program Files\gs\` (default)
   - ✅ Check "Add to PATH" if available
4. **Verify Installation**:
   ```powershell
   # Restart PowerShell, then test:
   gswin64c --version
   # Should show: 10.06.0 (or your version)
   ```

#### Method 2: Chocolatey Package Manager

```powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force
# Install Chocolatey if not installed
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Ghostscript
choco install ghostscript -y
```

### Installing Python Dependencies

```powershell
# Install OCRmyPDF (main OCR engine)
pip install ocrmypdf

# Optional: Update pip if needed
python -m pip install --upgrade pip

# Verify installation
pip show ocrmypdf
```

## Usage

### Basic Usage

Place PDF files in the same directory as the scripts and run:

```cmd
REM Lightweight text extraction (works immediately, no Ghostscript needed)
pdf2txt-lite.bat

REM Full OCR processing (requires Ghostscript)
pdf2txt.bat
```

**Alternative PowerShell method:**

```powershell
# Lightweight processing (no OCR, works immediately)
powershell -ExecutionPolicy Bypass -File "pdf2txt-lite.ps1"

# Full processing (requires Ghostscript)
powershell -ExecutionPolicy Bypass -File "pdf2txt.ps1"
```

### Making Commands Globally Available

To use the PDF converter from any directory (not just the installation folder):

#### Add to System PATH

```powershell
# Replace with your actual installation path
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Users\YourUsername\.vscode\pdf2txt_converter", "User")
```

#### Alternative: Manual PATH Setup

1. Press `Windows + R`, type `sysdm.cpl`, press Enter
2. Click "Environment Variables..."
3. In "User variables", find "Path" → "Edit" → "New"
4. Add your PDF converter directory path
5. Click "OK" on all dialogs
6. Restart terminal

#### Usage After PATH Setup

```cmd
# Now works from any directory
cd C:\Documents
pdf2txt-lite.bat         # Process PDFs in Documents folder
pdf2txt.bat              # Full OCR from anywhere

cd C:\Downloads
pdf2txt-lite.bat         # Process PDFs in Downloads folder
```

### Advanced Usage

Both scripts accept parameters:

```powershell
# Custom output directory and language
.\pdf2txt-lite.ps1 -OutputDir "my_output" -Languages "eng+fra"

# Custom DPI and processing settings
.\pdf2txt.ps1 -DPI 600 -Languages "eng" -PageSegMode 6 -TesseractTimeout 180
```

### Parameters

- `OutputDir`: Output directory (default: "read_pdf")
- `Languages`: Tesseract language codes (default: "eng")
- `DPI`: Image resolution for OCR (pdf2txt.ps1 only, default: 600)
- `PageSegMode`: Tesseract page segmentation mode (default: 6)
- `TesseractTimeout`: Timeout in seconds (default: 60 for lite, 180 for full)

### Common Language Codes

- `eng` - English
- `fra` - French
- `deu` - German
- `spa` - Spanish
- `eng+fra` - English + French (multilingual)

## Output

- Processed text files will be saved to the `read_pdf/` directory
- Files are automatically added to `.gitignore` if in a Git repository
- Text is cleaned and formatted with proper paragraph breaks

## Current Status

✅ **Working Immediately:**

- `pdf2txt-lite.bat` - Basic text extraction (no dependencies needed)
- Python 3.11 and pip
- Tesseract OCR engine
- Poppler tools (pdftotext, pdfinfo)
- OCRmyPDF Python package

❌ **For Full OCR (`pdf2txt.bat`):**

- Ghostscript (required for advanced OCR processing)

⚠️ **Admin Rights Required:**

- Chocolatey package installations need administrator privileges
- Manual Ghostscript installation is recommended

## Troubleshooting

### "The program 'gs' could not be executed"

This means Ghostscript is not installed or not in your PATH. Install Ghostscript and ensure it's added to your system PATH.

### "Access denied" with Chocolatey

Run PowerShell as Administrator or use manual installation methods.

### "No PDF files found"

Ensure PDF files are in the same directory as the PowerShell scripts.

## Testing

A test PDF file (`CA-Assignment2.pdf`) was found and the scripts successfully:

1. Detected the PDF file
2. Attempted OCR processing (failed only due to missing Ghostscript)
3. Created the output directory structure
4. Properly handled error conditions

## 🔧 Troubleshooting Guide

### Common Issues and Solutions

#### 1. "The program 'gs' could not be executed"

**Problem**: Ghostscript not found or not in PATH
**Solutions**:

```powershell
# Check if Ghostscript is installed
Get-ChildItem "C:\Program Files\gs*" -Directory

# If installed, add to PATH temporarily
$env:PATH += ";C:\Program Files\gs\gs10.06.0\bin"

# Test with Windows executable name
gswin64c --version
```

**Permanent PATH Fix**:

1. Press `Windows + R`, type `sysdm.cpl`, press Enter
2. Click "Environment Variables..."
3. In "System variables", find "Path" → "Edit" → "New"
4. Add: `C:\Program Files\gs\gs10.06.0\bin`
5. Restart terminal

#### 2. "Could not find program 'gswin64c' on the PATH"

**Problem**: OCRmyPDF can't find Ghostscript
**Solution**: The updated PowerShell scripts now automatically detect Windows Ghostscript executables (`gswin64c.exe`)

#### 3. "Access denied" with Chocolatey

**Problem**: Need administrator privileges
**Solutions**:

- Run PowerShell as Administrator
- Or use manual Ghostscript installation method
- Or install to user directory (non-admin Chocolatey setup)

#### 4. "No PDF files found"

**Problem**: PDFs not in the same directory as scripts
**Solution**: Place PDF files in the same folder as `pdf2txt.bat` and `pdf2txt-lite.bat`

#### 5. OCRmyPDF fails with timeout

**Problem**: Large or complex PDFs timing out
**Solution**: Increase timeout:

```powershell
.\pdf2txt.ps1 -TesseractTimeout 300  # 5 minutes
```

#### 6. Poor OCR quality

**Problem**: Text extraction is inaccurate
**Solutions**:

```powershell
# Try higher DPI
.\pdf2txt.ps1 -DPI 800

# Try different page segmentation mode
.\pdf2txt.ps1 -PageSegMode 4  # Single column
.\pdf2txt.ps1 -PageSegMode 11 # Sparse text
```

#### 7. "ExecutionPolicy" errors

**Problem**: PowerShell security restrictions
**Solution**: The `.bat` files automatically bypass this, but you can also:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Verification Commands

```powershell
# Test all components
Write-Host "=== System Check ==="
Write-Host "Python: " -NoNewline; python --version
Write-Host "Tesseract: " -NoNewline; tesseract --version | Select-String "tesseract"
Write-Host "pdftotext: " -NoNewline; pdftotext -v 2>&1 | Select-String "version"
Write-Host "OCRmyPDF: " -NoNewline; pip show ocrmypdf | Select-String "Version"
Write-Host "Ghostscript: " -NoNewline; gswin64c --version
```

### Performance Tips

1. **Use lite version for PDFs with existing text**: `pdf2txt-lite.bat`
2. **Process smaller files first**: The script automatically sorts by complexity
3. **Batch processing**: Put multiple PDFs in the folder for bulk conversion
4. **Language optimization**: Use specific language codes for better accuracy

### Getting Help

1. **Check logs**: Look in the `read_pdf/` directory for output files
2. **Verbose mode**: Edit scripts to remove `--quiet` flag for detailed output
3. **Manual testing**: Try individual commands to isolate issues:
   ```powershell
   pdftotext -layout your-file.pdf test-output.txt
   ```

## 🎯 Success Indicators

✅ **Everything Working**:

- `gswin64c --version` shows version number
- `pdf2txt-lite.bat` processes PDFs without errors
- `pdf2txt.bat` performs OCR without Ghostscript warnings
- Text files appear in `read_pdf/` directory with reasonable content

## 📞 Next Steps

1. ✅ **Test basic functionality**: `pdf2txt-lite.bat`
2. ✅ **Test full OCR**: `pdf2txt.bat`
3. 🎯 **Customize for your needs**: Adjust DPI, languages, timeouts
4. 🚀 **Integrate into workflow**: Use batch processing for multiple files
