@echo off
setlocal enabledelayedexpansion

set winpath=%5
set winpath=!winpath:\=\\!
for /f "delims=" %%a in ('wsl wslpath !winpath!') do @set newpath=%%a
bash -c "~/gitprojects/moodle343/node_modules/.bin/eslint -c ~/gitprojects/moodle343/.eslintrc %1=%2 !newpath!"
exit
