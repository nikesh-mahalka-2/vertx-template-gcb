#!/bin/bash

#  ----------------------------- Oracle DB ----------------------------------

# Uncomment this for oracle database

#chmod +x /workspace/check_oracle_table.sh

# To get access to docker store
#echo "docker login"
#docker login -u <username> -p $DOCKER_LOGIN

# docker-compose.yml is used by docker-compose

# Oracle database service
#echo "docker-compose up -d dbserver" 
#docker-compose up -d dbserver

#echo "checking Oracle database health to be healthy"

#DB_HEALTH=""
#while [ "${DB_HEALTH}" != "\"healthy\"" ]
#do
#  DB_HEALTH="$(docker inspect --format='{{json .State.Health.Status}}' dbserver)"
#  sleep 20
#  echo $DB_HEALTH
#done

# Application service: ojdbc7.jar dependency will be installed in local maven repo, maven source code will be build and
# application will be run against the Oracle Database
#echo "running docker-compose up appserver"
#docker-compose up appserver

# Checking existence of table app_server in Oracle Database created by application
#sudo docker exec dbserver /workspace/check_oracle_table.sh

#docker-compose down

#  ----------------------------- Postgres DB ----------------------------------

# Postgres database service
echo "docker-compose up -d dbserver"
docker-compose up -d dbserver

# Application service: ojdbc7.jar dependency will be installed in local maven repo, maven source code will be build and
# application will be run against the Postgres Database
echo "running docker-compose up appserver"
docker-compose up appserver

# Checking existence of table app_server in Postgres Database created by application
sudo docker exec dbserver /workspace/check_postgres_table.sh

docker-compose down
