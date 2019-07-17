#!/bin/bash

export MOODLEVERSION=354
# This file should no longer be needed - using moodle's phpcs instead

function install_composer {
    curl -sS https://getcomposer.org/installer -o composer-setup.php
    HASH=48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5
    echo "if installation fails, you may need to update hash"
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
}

function install_codechecker {

    sudo apt-get install -y php-codesniffer
    cd ~/gitprojects/moodle$MOODLEVERSION/local/codechecker
    # These are the default paths if codesniffer 2.x was installed
    # sudo cp -R moodle /usr/share/php/PHP/CodeSniffer/Standards
    # sudo cp -R PHPCompatibility /usr/share/php/PHP/CodeSniffer/Standards
    echo "ignore error about running composer as super user - it will continue"
    cd ~/
    composer global require "squizlabs/php_codesniffer=2.*"
    cd ~/gitprojects/moodle$MOODLEVERSION/local/codechecker
    cp -R moodle ~/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards
    cp -R PHPCompatibility ~/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards
    cp ~/gitprojects/moodlescripts/PHPCSAliases.php ~/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards
    sudo rm /usr/bin/phpcs
    sudo ln -s ~/.config/composer/vendor/squizlabs/php_codesniffer/scripts/phpcs /usr/bin/phpcs
    phpcs --config-set default_standard moodle
    echo "be sure to update file as described in Development Notes (this may be optional)"
}

install_composer
install_codechecker
