#!/bin/bash
DIR=$PWD

# Stop Services
$DIR/service_down.sh

# Re-Create MySQL Database
rm -R $DIR/mysql
mkdir $DIR/mysql
echo "*" > $DIR/mysql/.gitignore
echo "!.gitignore" >> $DIR/mysql/.gitignore

# Re-Create Laravel Directory
rm -R $DIR/src
mkdir $DIR/src
echo "*" > $DIR/src/.gitignore
echo "!.gitignore" >> $DIR/src/.gitignore
mkdir $DIR/src/public
echo "<h1>Make sure to install Laravel using 'install_laravel.sh'</h1>" > $DIR/src/public/index.php

# Start Services
$DIR/service_up.sh