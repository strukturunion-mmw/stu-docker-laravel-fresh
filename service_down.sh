DIR=$PWD
source .env
cd ../stu-docker-proxy/
sh ./proxy_down.sh
cd $DIR
docker-compose down