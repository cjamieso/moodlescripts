@echo off
setlocal enabledelayedexpansion

call :convert %5 result
set result5=!result!
bash -c "~/gitprojects/moodle341/node_modules/.bin/eslint -c ~/gitprojects/moodle341/.eslintrc %1=%2 %3 %4 !result5!"
exit

:convert
set fullpath=%5
set letter=!fullpath:~0,1!
set letter=!letter:C=c!
set letter=!letter:D=d!
set filename=!fullpath:~2!
set filename=!filename:\=/!
set result=/mnt/!letter!!filename!
goto:eof