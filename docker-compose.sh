#!/bin/bash

# Oracle image pull need authentication to Docker Store
echo "Login to Docker Store : docker login"
docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD

# docker-compose.yml is used by docker-compose
# Start Oracle database service
echo "Starting Oracle DB service: docker-compose up -d dbserver"
docker-compose up -d dbserver

echo "Checking Oracle database health ... "

DB_HEALTH=""
num_retry=1
until [ $num_retry -gt $DB_HLTH_CHK_MAX_RETRY ]
do
   DB_HEALTH="$(docker inspect --format='{{json .State.Health.Status}}' dbserver)"
   if [[ "${DB_HEALTH}" == "\"healthy\"" ]]; then
     break
   else
     echo "Oracle DB is $DB_HEALTH"
     echo "retry-$num_retry to check Oracle DB HEALTH"
     num_retry=$[$num_retry+1]
   fi
   sleep $DB_HLTH_CHK_SLEEP
done

if [[ "${DB_HEALTH}" == "\"healthy\"" ]]; then
  echo "Oracle DB is $DB_HEALTH"
else
  echo "Oracle DB is $DB_HEALTH"
  exit 1
fi

# Start application build service:
# ojdbc7.jar dependency will be installed in local maven repo.
# App Source code will be built and the application will run against the Oracle Database

echo "Starting application build service: docker-compose up appserver"
docker-compose up appserver

# Checking existence of table app_server in Oracle Database created by the application
sudo docker exec dbserver /workspace/check_oracle_table.sh

# Cleaning the docker-compose resources
docker-compose down
