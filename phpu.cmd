@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET me=%~n0
SET parent=%~dp0

IF NOT EXIST "%MOODLE_DOCKER_WWWROOT%" (
    ECHO Error: MOODLE_DOCKER_WWWROOT is not set or not an existing directory
    EXIT /B 1
)
SET DOCKERDIR=%MOODLE_DOCKER_WWWROOT%\moodle-docker

IF /I "%1%"=="drop" (
    echo "dropping tests"
    for /f "delims=" %%a in ('wsl phpu -d -o') do @set command=%%a
    %DOCKERDIR%/bin/moodle-docker-compose.cmd !command!
    EXIT 0
)

IF /I "%1%"=="init" (
    echo "initializing phpunit tests"
    for /f "delims=" %%a in ('wsl phpu -i -o') do @set command=%%a
    %DOCKERDIR%/bin/moodle-docker-compose.cmd !command!
    REM find way to have the phpu script output this command as well
    %DOCKERDIR%/bin/moodle-docker-compose.cmd exec webserver php admin/tool/phpunit/cli/util.php --buildcomponentconfigs
    EXIT 0
)

IF "%1%"=="" (
    ECHO "missing component to run behat tests on"
    EXIT /B 1
)
for /f "delims=" %%a in ('wsl phpu -t %1 -o') do @set command=%%a
%DOCKERDIR%/bin/moodle-docker-compose.cmd !command!
