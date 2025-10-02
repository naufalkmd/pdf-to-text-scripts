# PDF2TXT Converter

A simple and efficient PDF to text converter with two modes: standard and lite conversion.

## Features

- **Standard Mode (`pdf2txt`)**: Full-featured PDF text extraction
- **Lite Mode (`pdf2txt-lite`)**: Lightweight PDF text extraction with optimized processing
- **Batch Processing**: Automatically processes all PDF files in the current directory
- **Organized Output**: All converted text files are saved in the `read_pdf/` directory
- **Clean Filenames**: Automatically converts spaces to underscores in output filenames

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

#### Option 1: Using Chocolatey (Recommended)

1. **Install Chocolatey** (if not already installed):
   Open PowerShell as Administrator and run:

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```

2. **Install required dependencies**:

   ```powershell
   choco install git wget tesseract imagemagick
   # Note: You may also need to install poppler and ocrmypdf via pip:
   pip install ocrmypdf
   ```

3. **Clone the repository** (in Command Prompt or PowerShell):

   ```cmd
   git clone https://github.com/naufalkmd/pdf2txt_converter.git
   cd pdf2txt_converter
   ```

4. **Run the converter**:
   ```cmd
   pdf2txt.exe
   # or
   pdf2txt-lite.exe
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

To run `pdf2txt` from any directory without `./`, add the current directory to your PATH:

```bash
# Temporary (current session only)
export PATH="$PATH:$(pwd)"

# Now you can run:
pdf2txt
pdf2txt-lite
```

For permanent access, add the full path to your shell configuration file (`~/.zshrc`, `~/.bashrc`, etc.):

```bash
export PATH="$PATH:/full/path/to/pdf2txt_converter"
```

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
