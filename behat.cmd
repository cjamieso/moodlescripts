@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET me=%~n0
SET parent=%~dp0

IF NOT EXIST "%MOODLE_DOCKER_WWWROOT%" (
    ECHO Error: MOODLE_DOCKER_WWWROOT is not set or not an existing directory
    EXIT /B 1
)

IF /I "%1%"=="drop" (
    echo "starting containers"
    %DOCKERDIR%/bin/moodle-docker-compose exec webserver php admin/tool/behat/cli/util.php --drop
    EXIT 0
)

IF "%1%"=="" (
    ECHO "missing component to run behat tests on"
    EXIT /B 1
)

SET DOCKERDIR=%MOODLE_DOCKER_WWWROOT%\moodle-docker
IF "%2%"=="rerun" (
    %DOCKERDIR%/bin/moodle-docker-compose exec webserver php admin/tool/behat/cli/run.php --tags=@%1% --rerun
)
IF NOT "%2%"=="rerun" (
    %DOCKERDIR%/bin/moodle-docker-compose exec webserver php admin/tool/behat/cli/run.php --tags=@%1%
)

REM no option for paralle running of tests
REM should do auto-conversion of component/name to component_name
REM the course format tests are tricky - I used sed for this in linux
