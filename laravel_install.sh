#!/bin/bash
DIR=$PWD

# Stop Services
$DIR/service_down.sh

# Set environment
cp $DIR/.env.example $DIR/.env
source $DIR/.env

# Re-Create MySQL Database
rm -R $DIR/mysql
mkdir $DIR/mysql

# Re-Create Laravel Directory
rm -R $DIR/src
mkdir $DIR/src

# Install Laravel
docker-compose run --rm composer create-project laravel/laravel .

# Start Services
$DIR/service_up.sh

# Inject Project Vars into fresh Laravel ENV file
ENVFILE=$DIR/src/.env
sed -i '' -e "s/APP_NAME=Laravel/APP_NAME=\"$APP_NAME\"/g" $ENVFILE
sed -i '' -e "s/APP_URL=http:\/\/localhost/APP_URL=http:\/\/$URL/g" $ENVFILE
sed -i '' -e "s/DB_HOST=127.0.0.1/DB_HOST=mysql/g" $ENVFILE
sed -i '' -e "s/DB_DATABASE=laravel/DB_DATABASE=$MYSQL_DATABASE/g" $ENVFILE
sed -i '' -e "s/DB_USERNAME=root/DB_USERNAME=$MYSQL_USER/g" $ENVFILE
sed -i '' -e "s/DB_PASSWORD=/DB_PASSWORD=$MYSQL_PASSWORD/g" $ENVFILE

# Update permissions in Laravel dir
docker-compose exec -d -w /var/www/html php chown -R www-data:www-data .

# Run default Laravel Migrations
sleep 5
docker-compose run --rm artisan migrate

