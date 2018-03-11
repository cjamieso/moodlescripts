@echo off
setlocal enabledelayedexpansion

IF /I "%3%"=="--standard" (
    call :convert %6 result
    set result1=!result!
    wsl phpcs %1=%2 %3=%4 !result1!
)
IF /I "%5%"=="--standard" (
    call :convert %4 result
    set result1=!result!
    wsl phpcs %1=%2 %5=%6 !result1!
)
exit

:convert
set fullpath=%1
set letter=!fullpath:~0,1!
set letter=!letter:C=c!
set letter=!letter:D=d!
set filename=!fullpath:~2!
set filename=!filename:\=/!
set result=/mnt/!letter!!filename!
goto:eof