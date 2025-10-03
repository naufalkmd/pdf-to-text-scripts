# PDF2TXT Converter

### Introduction

pdf2txt_converter is a tool designed to bridge the gap between PDF documents and code editors or AI-powered agents. While modern development environments like VSCode, enhanced by GitHub Copilot or other AI agents, excel at reading and assisting with code and text files, they struggle to directly extract information from PDF files—especially when those PDFs contain screenshots or scanned images rather than selectable text. This limitation can hinder productivity, making it difficult to reference documentation, share code snippets, or extract insights from visual-only PDFs.

### Problem Addressed

This tool solves a common developer pain point: GitHub Copilot and other AI agents in VSCode cannot natively read or interpret content from PDF files, particularly when the PDF includes screenshots or non-selectable text. pdf2txt_converter enables seamless conversion of such PDFs into readable text, unlocking their content for use within your favorite coding tools and workflows.

## Features

- **Cross-Platform Support**: Works on macOS, Linux, and Windows
- **Standard Mode (`pdf2txt`)**: Full-featured PDF text extraction with OCR
- **Lite Mode (`pdf2txt-lite`)**: Lightweight PDF text extraction without OCR (works without Ghostscript)
- **Batch Processing**: Automatically processes all PDF files in the current directory
- **Organized Output**: All converted text files are saved in the `read_pdf/` directory
- **Clean Filenames**: Automatically converts spaces to underscores in output filenames

## File Structure

### For Mac/Linux Users:

- `pdf2txt` - Full OCR processing (bash)
- `pdf2txt-lite` - Lightweight OCR version (bash)

### For Windows Users:

- `pdf2txt.ps1` + `pdf2txt.bat` - Full OCR version (PowerShell + launcher) - _Requires Ghostscript_
- `pdf2txt-lite.ps1` + `pdf2txt-lite.bat` - Basic text extraction, no OCR (PowerShell + launcher) - _Works immediately_
- `WINDOWS_SETUP.md` - Detailed Windows installation guide

**Quick Start for Windows:**

1. Download and install [Ghostscript](https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/)
2. Clone this repository
3. Double-click `pdf2txt.bat` for full OCR or `pdf2txt-lite.bat` for basic extraction

## Installation

### System Requirements

- **macOS**: macOS 10.14 or later
- **Windows**: Windows 10 or later
- **Linux**: Most modern distributions
- Terminal/Command Line access

### macOS Installation

1. **Install Homebrew** (if not already installed):

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install required dependencies**:

   ```bash
   brew install git wget ocrmypdf poppler imagemagick tesseract-lang
   ```

3. **Clone the repository**:

   ```bash
   git clone https://github.com/naufalkmd/pdf2txt_converter.git
   cd pdf2txt_converter
   ```

4. **Make executables runnable**:

   ```bash
   chmod +x pdf2txt pdf2txt-lite
   ```

5. **Test the installation**:
   ```bash
   ./pdf2txt --help
   ```

### Windows Installation

#### Option 1: Quick Installation (Recommended)

1. **Install Ghostscript** (Required for full OCR):

   - Go to [Ghostscript Releases](https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/)
   - Download `gs10060w64.exe` (Windows 64-bit installer)
   - Run installer as Administrator
   - Install to default location: `C:\Program Files\gs\`

2. **Install Python dependencies**:

   ```powershell
   pip install ocrmypdf
   ```

3. **Clone the repository**:

   ```cmd
   git clone https://github.com/naufalkmd/pdf2txt_converter.git
   cd pdf2txt_converter
   ```

4. **Test the installation**:

   ```cmd
   REM Test basic extraction (works without Ghostscript)
   pdf2txt-lite.bat

   REM Test full OCR processing (requires Ghostscript)
   pdf2txt.bat
   ```

5. **Make commands globally available** (Optional):

   Add the converter to your system PATH to use from any directory:

   ```powershell
   # Add PDF converter to PATH (replace with your actual path)
   [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Users\YourUsername\.vscode\pdf2txt_converter", "User")
   ```

   After this, you can use the commands from anywhere:

   ```cmd
   cd C:\Documents
   pdf2txt-lite.bat    # Works from any directory
   pdf2txt.bat         # Works from any directory
   ```

#### Option 2: Using Chocolatey

1. **Install Chocolatey** (requires Administrator):

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```

2. **Install dependencies**:
   ```powershell
   choco install ghostscript git tesseract -y
   pip install ocrmypdf
   ```

#### Option 2: Using WSL (Windows Subsystem for Linux)

1. **Install WSL** (if not already installed):

   ```powershell
   wsl --install
   ```

2. **Open WSL terminal** and follow the Linux/Ubuntu installation steps:
   ```bash
   sudo apt update
   sudo apt install git wget
   git clone https://github.com/naufalkmd/pdf2txt_converter.git
   cd pdf2txt_converter
   chmod +x pdf2txt pdf2txt-lite
   ```

### Linux Installation

1. **Install dependencies** (Ubuntu/Debian):

   ```bash
   sudo apt update
   sudo apt install git wget tesseract-ocr tesseract-ocr-eng poppler-utils imagemagick python3-pip
   pip3 install ocrmypdf
   ```

   **For CentOS/RHEL/Fedora**:

   ```bash
   sudo yum install git wget tesseract poppler-utils ImageMagick python3-pip
   # or for newer versions:
   sudo dnf install git wget tesseract poppler-utils ImageMagick python3-pip
   pip3 install ocrmypdf
   ```

2. **Clone the repository**:

   ```bash
   git clone https://github.com/naufalkmd/pdf2txt_converter.git
   cd pdf2txt_converter
   ```

3. **Make executables runnable**:

   ```bash
   chmod +x pdf2txt pdf2txt-lite
   ```

4. **Test the installation**:
   ```bash
   ./pdf2txt --help
   ```

## Usage

### Basic Usage

Place your PDF files in the same directory as the executables and run:

```bash
# Standard conversion
./pdf2txt

# Lite conversion (optimized/faster)
./pdf2txt-lite
```

### Convert Specific PDF

```bash
# Standard mode
./pdf2txt "your-file.pdf"

# Lite mode
./pdf2txt-lite "your-file.pdf"
```

### Running from Anywhere (Optional)

**For Mac/Linux:**
To run `pdf2txt` from any directory without `./`, add the current directory to your PATH:

```bash
# Temporary (current session only)
export PATH="$PATH:$(pwd)"

# Permanent (add to ~/.bashrc or ~/.zshrc)
echo 'export PATH="$PATH:/path/to/pdf2txt_converter"' >> ~/.bashrc
```

**For Windows:**
Add the PDF converter directory to your system PATH:

```powershell
# Add to PATH permanently (replace with your actual path)
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\path\to\pdf2txt_converter", "User")
```

After setting up PATH, you can run from any directory:
pdf2txt
pdf2txt-lite

````

For permanent access, add the full path to your shell configuration file (`~/.zshrc`, `~/.bashrc`, etc.):

```bash
export PATH="$PATH:/full/path/to/pdf2txt_converter"
````

## Output Structure

```
pdf2txt_converter/
├── pdf2txt                 # Standard converter executable
├── pdf2txt-lite           # Lite converter executable
├── your-file.pdf          # Input PDF files
├── another-file.pdf
└── read_pdf/              # Output directory
    ├── your-file.txt      # Converted text files
    └── another-file.txt
```

## Examples

### Converting a Single PDF

```bash
$ ./pdf2txt "Research Paper.pdf"
Processing: Research Paper.pdf
  Saved -> read_pdf/Research_Paper.txt
Done. Output files in: read_pdf
```

### Batch Processing Multiple PDFs

Place multiple PDF files in the directory and run:

```bash
$ ./pdf2txt
Processing: Document1.pdf
  Saved -> read_pdf/Document1.txt
Processing: Document2.pdf
  Saved -> read_pdf/Document2.txt
Processing: Document3.pdf
  Saved -> read_pdf/Document3.txt
Done. Output files in: read_pdf
```

## Differences Between Standard and Lite

| Feature          | Standard (`pdf2txt`)   | Lite (`pdf2txt-lite`) |
| ---------------- | ---------------------- | --------------------- |
| Processing Speed | Standard               | Faster                |
| Text Quality     | Full extraction        | Optimized extraction  |
| File Size        | Slightly larger output | Optimized output size |
| Memory Usage     | Standard               | Lower memory usage    |

## Troubleshooting

### "Command not found" Error

If you get a "command not found" error:

1. **Use `./` prefix**:

   ```bash
   ./pdf2txt instead of pdf2txt
   ```

2. **Check executable permissions**:

   ```bash
   ls -la pdf2txt pdf2txt-lite
   # Should show -rwxr-xr-x (executable permissions)
   ```

3. **Fix permissions if needed**:
   ```bash
   chmod +x pdf2txt pdf2txt-lite
   ```

### "Permission denied" Error

```bash
chmod +x pdf2txt pdf2txt-lite
```

### Output Directory Missing

The `read_pdf/` directory is created automatically. If you encounter issues:

```bash
mkdir -p read_pdf
```

## 🔧 Troubleshooting

### Windows Issues

**"Ghostscript not found" Error:**

```cmd
REM Download and install Ghostscript first
REM https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/
REM Then test:
gswin64c --version
```

**PowerShell Execution Policy:**

```powershell
REM Use the .bat files instead of direct PowerShell execution
pdf2txt-lite.bat
pdf2txt.bat
```

**No text extracted:**

- Try the lite version first: `pdf2txt-lite.bat`
- For scanned PDFs, ensure Ghostscript is installed for OCR

### Mac/Linux Issues

**Missing dependencies:**

```bash
# macOS
brew install poppler tesseract ocrmypdf

# Ubuntu/Debian
sudo apt install poppler-utils tesseract-ocr
pip3 install ocrmypdf
```

**Permission denied:**

```bash
chmod +x pdf2txt pdf2txt-lite
```

### General Issues

**No PDF files found:**

- Ensure PDF files are in the same directory as the scripts
- Check file permissions

**Poor OCR quality:**

- Try different DPI settings (Windows): `pdf2txt.ps1 -DPI 800`
- Use appropriate language codes for non-English text

**For detailed troubleshooting, see `WINDOWS_SETUP.md`**

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is open source. Feel free to use, modify, and distribute.

## Support

If you encounter any issues or have questions:

1. Check the [Troubleshooting](#troubleshooting) section
2. Open an issue on GitHub
3. Provide details about your system and the error message

## Changelog

### v1.0.0

- Initial release
- Standard and lite conversion modes
- Batch processing support
- Automatic output directory creation
- Clean filename conversion

---

**Made with ❤️ by [naufalkmd](https://github.com/naufalkmd)**
