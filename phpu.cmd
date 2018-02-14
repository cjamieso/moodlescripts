@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET me=%~n0
SET parent=%~dp0

IF NOT EXIST "%MOODLE_DOCKER_WWWROOT%" (
    ECHO Error: MOODLE_DOCKER_WWWROOT is not set or not an existing directory
    EXIT /B 1
)

IF "%1%"=="" (
    ECHO "missing phpunit component to run tests on"
    EXIT /B 1
)

SET DOCKERDIR=%MOODLE_DOCKER_WWWROOT%\moodle-docker
%DOCKERDIR%/bin/moodle-docker-compose exec webserver vendor/bin/phpunit -c %1%

REM no option for auto-determining based on the diff (would require php script)
REM could do via bash -c (and run php script) if needed
