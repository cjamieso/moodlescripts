@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET me=%~n0
SET parent=%~dp0

IF NOT EXIST "%MOODLE_DOCKER_WWWROOT%" (
    ECHO Error: MOODLE_DOCKER_WWWROOT is not set or not an existing directory
    EXIT /B 1
)

IF "%1%"=="" (
    ECHO "missing command for type of test to init"
    EXIT /B 1
)

SET DOCKERDIR=%MOODLE_DOCKER_WWWROOT%\moodle-docker

IF /I "%1%"=="phpunit" (
    %DOCKERDIR%/bin/moodle-docker-compose.cmd exec webserver php admin/tool/phpunit/cli/init.php
    %DOCKERDIR%/bin/moodle-docker-compose.cmd exec webserver php admin/tool/phpunit/cli/util.php --buildcomponentconfigs
)
IF /I "%1%"=="behat" (
    %DOCKERDIR%/bin/moodle-docker-compose.cmd exec webserver php admin/tool/behat/cli/init.php
)

REM no option yet for behat parallel tests
REM no option for phpmd setup and running
