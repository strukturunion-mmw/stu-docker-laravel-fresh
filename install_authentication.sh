#!/bin/bash

# Inspired by https://www.youtube.com/watch?v=K-JrkQxLAms

# Install Laravel breeze
docker-compose run --rm composer require laravel/breeze --dev
docker-compose run --rm artisan breeze:install
docker-compose run --rm npm install
docker-compose run --rm npm run dev
docker-compose run --rm artisan migrate

# Set base Dir
DIR=$PWD

# Update User-Model to implement Verification Email
FILE=$DIR/src/app/Models/User.php
FIND="class User extends Authenticatable"
REPLACE="class User extends Authenticatable implements MustVerifyEmail"
sed -i '' -e "s/$FIND/$REPLACE/" $FILE

# Update Dashboard Route to allow access only to Email-Verified Users
FILE=$DIR/src/routes/web.php
FIND="middleware(\['auth'\])->name('dashboard')"
REPLACE="middleware\(['auth','verified']\)->name\('dashboard'\)"
sed -i '' -e "s/$FIND/$REPLACE/" $FILE

# Inject Sender Email into project ENV file
source $DIR/.env
FILE=$DIR/src/.env
FIND="MAIL_FROM_ADDRESS=null"
REPLACE="MAIL_FROM_ADDRESS=$ADMIN_EMAIL"
sed -i '' -e "s/$FIND/$REPLACE/" $FILE
