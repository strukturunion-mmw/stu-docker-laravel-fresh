#!/bin/bash
DIR=$PWD

# Stop Services
$DIR/service_down.sh

# Verbose some output
clear
echo ""
echo "We are setting up your new Laravel instance. Please provide some parameters."
echo "Just hit <ENTER> to use default values for any question."
echo ""

# Set environment
cp -rf $DIR/.env.example $DIR/.env
ENVFILE=$DIR/.env

# Inject provided parameters into ENV file
echo "What is the name of your App?"
read appname
if [ -n "$appname" ]
then
  sed -i '' -e "s/Fresh Laravel App/$appname/g" $ENVFILE
fi
echo ""
echo "Give a unique identifier for the docker service (zB: laravel_app)"
read servicename
if [ -n "$servicename" ]
then
  sed -i '' -e "s/laravel_test/$servicename/g" $ENVFILE
fi
echo ""
echo "At what URL will the app be accessible (https://app.com)"
read appurl
if [ -n "$appurl" ]
then
  sed -i '' -e "s#test.local#$appurl#g" $ENVFILE
fi
echo ""
echo "What's the Admin's Email address?"
read adminemail
if [ -n "$adminemail" ]
then
  sed -i '' -e "s/info@domain.com/$adminemail/g" $ENVFILE
fi
echo ""
echo "Name the MySQL database:"
read dbname
if [ -n "$dbname" ]
then
  sed -i '' -e "s/laraveldb/$dbname/g" $ENVFILE
fi
echo ""
echo "Name the MySQL database user:"
read dbuser
if [ -n "$dbuser" ]
then
  sed -i '' -e "s/laravelapp/$dbuser/g" $ENVFILE
fi
echo ""
echo "Set a MySQL database password:"
read dbpassword
if [ -n "$dbpassword" ]
then
  sed -i '' -e "s/You-will-never-guesS/$dbpassword/g" $ENVFILE
fi

# USE ENV file for installation
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

