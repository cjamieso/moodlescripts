@echo off
setlocal enabledelayedexpansion

set winpath=%4
set winpath=!winpath:\=\\!
for /f "delims=" %%a in ('wsl wslpath !winpath!') do @set newpath=%%a
wsl phpcs %1=%2 !newpath!
exit
