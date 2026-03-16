@echo off
echo.
echo ===================================================
echo   Compilazione AutoAccenti in corso...
echo ===================================================
echo.

set COMPILER="C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
set SOURCE="%~dp0src\AutoAccenti.ahk"
set OUTDIR="%~dp0release"
set ICON="%~dp0src\assets\AutoAccenti.ico"

if not exist %COMPILER% (
    echo [ERRORE] Compilatore Ahk2Exe non trovato in C:\Program Files\AutoHotkey\Compiler\
    echo Assicurati di aver installato AutoHotkey e il componente Compiler.
    pause
    exit /b 1
)

if not exist %OUTDIR% (
    mkdir %OUTDIR%
)

echo - Compilazione versione a 64-bit (x64)
%COMPILER% /in %SOURCE% /out %OUTDIR%\AutoAccenti_x64.exe /base "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" /icon %ICON%

echo - Compilazione versione a 32-bit (x86)
%COMPILER% /in %SOURCE% /out %OUTDIR%\AutoAccenti_x86.exe /base "C:\Program Files\AutoHotkey\v2\AutoHotkey32.exe" /icon %ICON%

echo.
echo Compilazione completata con successo! I file si trovano nella cartella "build".
echo.
pause
