@echo off

set WIX_PATH="C:\Program Files (x86)\WiX Toolset v3.11\bin"
set FLUTTER_BUILD_DIR=build\windows\x64\runner\Release
set WIX_SOURCE_DIR=installer\wix
set MSI_OUTPUT_DIR=build\msi

rem Clean previous build artifacts
if exist %MSI_OUTPUT_DIR% rmdir /s /q %MSI_OUTPUT_DIR%
mkdir %MSI_OUTPUT_DIR%

rem Build Flutter application for Windows
flutter build windows
if %errorlevel% neq 0 (
    echo Flutter build failed.
    exit /b %errorlevel%
)

rem Compile WiX source
%WIX_PATH%\candle.exe -nologo -dBuildDir=%FLUTTER_BUILD_DIR% %WIX_SOURCE_DIR%\Product.wxs -o %MSI_OUTPUT_DIR%\Product.wixobj
if %errorlevel% neq 0 (
    echo WiX candle.exe failed.
    exit /b %errorlevel%
)

rem Link WiX object to MSI
%WIX_PATH%\light.exe -nologo -ext WixUIExtension %MSI_OUTPUT_DIR%\Product.wixobj -o %MSI_OUTPUT_DIR%\LocalizationUITool.msi
if %errorlevel% neq 0 (
    echo WiX light.exe failed.
    exit /b %errorlevel%
)

echo MSI package built successfully at %MSI_OUTPUT_DIR%\LocalizationUITool.msi