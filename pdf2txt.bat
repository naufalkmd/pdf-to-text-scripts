@echo off
REM pdf2txt.bat - Easy launcher for PowerShell script
echo Starting PDF to Text Converter (Full Version)...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0pdf2txt.ps1" %*
echo.
echo Processing complete. Check the 'read_pdf' directory for output files.
pause