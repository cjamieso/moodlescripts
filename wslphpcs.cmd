@echo off
setlocal enabledelayedexpansion

echo %*
call :convert %1 result
set result1=!result!
bash -c "phpcs %2=%3 %4=%5 !result1!"
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