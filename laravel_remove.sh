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
echo "<pre>Make sure to install Laravel using 'laravel_install.sh'</pre>" > $DIR/src/public/index.php

# Reset Environment
rm $DIR/.env
cp $DIR/.env.example $DIR/.env

# Start Services
$DIR/service_up.sh