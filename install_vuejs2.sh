#!/bin/bash
BREEZEINSTALL=$1

# Inspired by https://www.youtube.com/watch?v=uUDxCUVkdLY&list=TLPQMDYwMzIwMjG2UGTiniXZ7A

# Set base Dir
DIR=$PWD

# Install initial NPM packages
docker-compose run --rm npm install

# Install VueJS 2
docker-compose run --rm npm install --save vue vue-template-compiler vuex vue-router

# Copy VueJS Blade and Sample component from Templates
cp $DIR/vuejs2/vuejs-app.blade.php $DIR/src/resources/views/
mkdir $DIR/src/resources/js/vuejs
cp $DIR/vuejs2/vuejs-component.vue $DIR/src/resources/js/vuejs/
cp $DIR/vuejs2/routes.js $DIR/src/resources/js/vuejs/

# exchange default blade in web routes
FILE=$DIR/src/routes/web.php
FIND="return view('welcome');"
REPLACE="return view('vuejs-app');"
sed -i '' -e "s/$FIND/$REPLACE/" $FILE

# add .vue() to webpack.mix.js
FILE=$DIR/src/webpack.mix.js
FIND="'public\/js')"
REPLACE="'public\/js').vue()"
sed -i '' -e "s/$FIND/$REPLACE/" $FILE

# Add Vue initialisation snippet to to app.js
FILE=$DIR/src/resources/js/app.js
cat $DIR/vuejs2/app.js >> $FILE

# Intermittend NPM Development build
docker-compose run --rm npm run dev

# First productive Development build
docker-compose run --rm npm run dev

# Install Tailwind CSS if Breeze was not installed
if [ $BREEZEINSTALL != "y" ]
then

# Install tailwind css
docker-compose run --rm npm install -D tailwindcss@latest postcss@latest autoprefixer@latest

# add require("tailwindcss"), to webpack.mix.js
FILE=$DIR/src/webpack.mix.js
FIND=".postCss('resources\/css\/app.css', 'public\/css', \["
REPLACE=".postCss('resources\/css\/app.css', 'public\/css', \[require(\"tailwindcss\"),"
sed -i '' -e "s/$FIND/$REPLACE/" $FILE

# Add tailwind components to /resources/css/app.css
FILE=$DIR/src/resources/css/app.css
cat $DIR/vuejs2/app.css >> $FILE

# Complete installation with NPM Development build
docker-compose run --rm npm run dev

fi
