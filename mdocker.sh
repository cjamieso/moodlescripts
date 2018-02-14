#!/bin/bash

if [ -z "$1" ]; then
    echo "missing argument for moodleversion"
fi
if [ -z "$2" ]; then
    echo "missing command to send to moodle-docker compose"
fi

if [ "$2" = "start" ]; then
    ~/gitprojects/moodle$1/moodle-docker/bin/moodle-docker-compose up -d
elif [ "$2" = "selenium" ]; then
    ID="(docker.exe ps -a --filter 'name=selenium' --format '{{.ID}}')"
    docker.exe stop $ID
    docker.exe rm $ID
elif [ "$2" = "stop" ]; then
    ~/gitprojects/moodle$1/moodle-docker/bin/moodle-docker-compose stop
elif [ "$2" = "destroy" ]; then
    ~/gitprojects/moodle$1/moodle-docker/bin/moodle-docker-compose down
elif [ "$2" = "install" ]; then
    ~/gitprojects/moodle$1/moodle-docker/bin/moodle-docker-compose exec webserver php admin/cli/install_database.php --agree-license --fullname="Docker moodle" --shortname="docker_moodle" --adminpass="test" --adminemail="cjamieso@ualberta.ca"
elif [ "$2" = "post" ]; then
    docker.exe exec -it moodldocker_webserver_1 bash -c "echo -e 'post_max_size = 256M \nupload_max_filesize = 256M' > /usr/local/etc/php/php.ini"
else
    echo "command not recognized, valid options are: {start|selenium|stop|destroy|install|post}"
fi

echo "install at: http://localhost:8000/"
echo "faildumps at: http://localhost:8000/_/faildumps/"
