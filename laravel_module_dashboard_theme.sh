#!/bin/bash

# Implementing Midone Dashboard theme by Muhammad Rizki A / Left4code (dev.muhammadrizki@gmail.com)

# Set base Dir
DIR=$PWD

# Rename Inertia Webpack Config files
mv $DIR/src/tailwind.config.js $DIR/src/tailwind.config.js.INERTIA
mv $DIR/src/webpack.config.js $DIR/src/webpack.config.js.INERTIA
mv $DIR/src/webpack.mix.js $DIR/src/webpack.mix.js.INERTIA

# Pull in sample dashboard theme files and webpack config
cp -R $DIR/dashboard/app $DIR/src/resources
cp $DIR/dashboard/tailwind.config.js $DIR/src
cp $DIR/dashboard/webpack.mix.js $DIR/src

# Inject dependencies into NPM package.json
FILE=$DIR/src/package.json
FIND="\"devDependencies\": {"
REPLACE=$(<"$DIR/dashboard/inject_to_package.json")
sed -i '' -e "s/$FIND/$REPLACE/" $FILE

# Install NPM dependencies
docker-compose run --rm npm install

# First productive Development build
docker-compose run --rm npm run dev

# Complete installation with NPM Development build
docker-compose run --rm npm run dev
