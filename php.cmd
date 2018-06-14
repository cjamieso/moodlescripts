@echo off
setlocal enabledelayedexpansion

set winpath=%9
set winpath=!winpath:\=\\!
for /f "delims=" %%a in ('wsl wslpath !winpath!') do @set newpath=%%a

wsl php %1 %2 %3 %4=%5 %6 %7=%8 !newpath!
