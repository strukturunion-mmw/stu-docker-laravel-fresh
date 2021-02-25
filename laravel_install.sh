#!/bin/bash
DIR=$PWD

# Stop Services
$DIR/service_down.sh

# Set environment
cp $DIR/.env.example $DIR/.env

# Re-Create MySQL Database
rm -R $DIR/mysql
mkdir $DIR/mysql

# Re-Create Laravel Directory
rm -R $DIR/src
mkdir $DIR/src

# Install Laravel
docker-compose run --rm composer create-project laravel/laravel .
docker-compose run --rm artisan migrate

# Start Services
$DIR/service_up.sh