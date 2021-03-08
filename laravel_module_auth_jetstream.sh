#!/bin/bash

# Inspired by https://www.youtube.com/watch?v=K-JrkQxLAms

# Install Laravel breeze
docker-compose run --rm composer require laravel/jetstream
docker-compose run --rm artisan jetstream:install livewire
docker-compose run --rm npm install
docker-compose run --rm npm run dev
docker-compose run --rm artisan migrate

# Set base Dir
DIR=$PWD

# Inject Sender Email into project ENV file
source $DIR/.env
FILE=$DIR/src/.env
FIND="MAIL_FROM_ADDRESS=null"
REPLACE="MAIL_FROM_ADDRESS=$ADMIN_EMAIL"
sed -i '' -e "s/$FIND/$REPLACE/" $FILE