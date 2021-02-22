#!/bin/bash
DIR=$PWD
source .env
cd ../stu-docker-proxy/
sh ./proxy_up.sh
cd $DIR
docker-compose up -d laravel