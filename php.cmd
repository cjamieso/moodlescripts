@echo off
setlocal enabledelayedexpansion

call :convert %9 result
set result1=!result!
wsl php %1 %2 %3 %4=%5 %6 %7=%8 !result1!

:convert
set fullpath=%1
set letter=!fullpath:~0,1!
set letter=!letter:C=c!
set letter=!letter:D=d!
set filename=!fullpath:~2!
set filename=!filename:\=/!
set result=/mnt/!letter!!filename!
goto:eof