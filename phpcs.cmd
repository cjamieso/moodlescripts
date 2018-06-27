@echo off
setlocal enabledelayedexpansion

IF /I "%3%"=="--standard" (
    set winpath=%6
    set winpath=!winpath:\=\\!
    for /f "delims=" %%a in ('wsl wslpath !winpath!') do @set newpath=%%a
    wsl phpcs %1=%2 %3=%4 !newpath!
)
IF /I "%5%"=="--standard" (
    set winpath=%4
    set winpath=!winpath:\=\\!
    for /f "delims=" %%a in ('wsl wslpath !winpath!') do @set newpath=%%a
    wsl phpcs %1=%2 %5=%6 !newpath!
)
exit
