@echo off
REM pdf2txt-lite.bat - Lightweight text extraction without OCR
echo Starting PDF to Text Converter (Lite Version - No OCR)...
echo This version works without Ghostscript installation.
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0pdf2txt-lite.ps1" %*
echo.
echo Processing complete. Check the 'read_pdf' directory for output files.
pause