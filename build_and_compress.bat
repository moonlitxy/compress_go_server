@echo off
setlocal

:: ==============================
:: 1. Build Target Configuration
:: ==============================
:: Target OS (common: linux, windows, darwin)
set GOOS=linux
:: Target Arch (common: amd64, arm64)
set GOARCH=amd64

:: ==============================
:: 2. Build Parameters
:: ==============================
:: CGO_ENABLED=0: Disable CGO for static binary
set CGO_ENABLED=0

:: 3. Output Filename Handling (Add .exe for Windows)
set OUTPUT_NAME=server
if "%GOOS%"=="windows" set OUTPUT_NAME=server.exe

echo ==========================================
echo Start Building...
echo Target System: %GOOS%
echo Target Arch  : %GOARCH%
echo Output File  : %OUTPUT_NAME%
echo ==========================================

:: 4. Execute Build
:: -ldflags="-s -w": Strip debug info and symbols to reduce size
go build -ldflags="-s -w" -o %OUTPUT_NAME% main.go

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed!
    pause
    exit /b 1
)

echo [SUCCESS] Build completed.

:: 5. Compression (if UPX exists)
where upx >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Found UPX, compressing...
    upx -9 %OUTPUT_NAME%
) else (
    echo [WARN] UPX not found, skipping compression.
)

echo.
echo Done.
endlocal
