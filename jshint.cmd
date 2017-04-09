@echo off
setlocal enabledelayedexpansion

call :convert %3 result
set result3=!result!
call :convert %5 result
set result5=!result!
bash -c "jshint !result3! %1 %4 !result5!"
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