@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET me=%~n0
SET parent=%~dp0

IF NOT EXIST "%MOODLE_DOCKER_WWWROOT%" (
    ECHO Error: MOODLE_DOCKER_WWWROOT is not set or not an existing directory
    EXIT /B 1
)

IF "%1%"=="" (
    ECHO "missing command to send to moodle-docker compose"
    EXIT /B 1
)

SET DOCKERDIR=%MOODLE_DOCKER_WWWROOT%\moodle-docker

IF /I "%1%"=="start" (
    echo "starting containers"
    %DOCKERDIR%/bin/moodle-docker-compose up -d
)
IF /I "%1%"=="selenium" (
    echo "wiping selenium"
    for /f "delims=" %%i in ('docker ps -a --filter "name=selenium" --format "{{.ID}}"') do set ID=%%i
    docker stop !ID!
    docker rm !ID!
)
IF /I "%1%"=="stop" (
    echo "stopping containers"
    %DOCKERDIR%/bin/moodle-docker-compose stop
)
IF /I "%1%"=="destroy" (
    echo "destroying containers"
    %DOCKERDIR%/bin/moodle-docker-compose down
)
IF /I "%1%"=="install" (
    echo "installing moodle"
    %DOCKERDIR%/bin/moodle-docker-compose exec webserver php admin/cli/install_database.php --agree-license --fullname="Docker moodle" --shortname="docker_moodle" --adminpass="test" --adminemail="cjamieso@ualberta.ca"
)
IF /I "%1%"=="post" (
    echo "changing post size"
    docker.exe exec -it moodledocker_webserver_1 bash -c "ECHO -e 'post_max_size = 256M \nupload_max_filesize = 256M' > /usr/local/etc/php/php.ini"
)

ECHO "install at: http://localhost:8000/"
ECHO "faildumps at: http://localhost:8000/_/faildumps/"
