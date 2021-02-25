#!/bin/bash
DIR=$PWD

# Stop Services
$DIR/service_down.sh

# Set environment
cp $DIR/.env.example $DIR/.env
source=$DIR/.env

# Re-Create MySQL Database
rm -R $DIR/mysql
mkdir $DIR/mysql

# Re-Create Laravel Directory
rm -R $DIR/src
mkdir $DIR/src

# Install Laravel
docker-compose run --rm composer create-project laravel/laravel .

# Update fresh Laravel ENV file
ENVFILE=$DIR/src/.env
sed -i 's/#APP_NAME=Laravel/APP_NAME=$APP_NAME/g' $ENVFILE
sed -i 's/#DB_HOST=127.0.0.1/DB_HOST=mysql/g' $ENVFILE
sed -i 's/#DB_DATABASE=laravel/DB_DATABASE=$DB_DATABASE/g' $ENVFILE
sed -i 's/#DB_USERNAME=root/DB_USERNAME=$DB_USERNAME/g' $ENVFILE
sed -i 's/#DB_PASSWORD=/DB_PASSWORD=$DB_PASSWORD/g' $ENVFILE


docker-compose run --rm artisan migrate

# Start Services
$DIR/service_up.sh