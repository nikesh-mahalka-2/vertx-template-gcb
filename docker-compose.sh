#!/bin/bash

#
#  docker-compose.sh : shell script to perform the following tasks:
#  1. login to docker
#  2. Create Oracle DB service
#  3. Check health of Oracle DB service
#  4. Create Application build service
#  5. Check the existence of app_message table in Oracle DB
#  6. Stop the services
#

DB_HEALTH=""

#
# Function to check Oracle DB service health
# 
check_database_health()
{
	num_retry=1
	until [ $num_retry -gt $DB_HLTH_CHK_MAX_RETRY ]
	do
	   DB_HEALTH="$(docker inspect --format='{{json .State.Health.Status}}' dbserver)"
	   if [[ "${DB_HEALTH}" == "\"healthy\"" ]]; then
	     break
	   else
	     echo "Oracle DB service is $DB_HEALTH"
	     echo "retry-$num_retry to check health of Oracle DB service"
	     num_retry=$[$num_retry+1]
	   fi
	   sleep $DB_HLTH_CHK_SLEEP
	done
}

# Oracle DB image pull need authentication to Docker Store
echo "Login to Docker Store : docker login"
docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD

# docker-compose.yml is used by docker-compose
# Start Oracle DB service
echo "Starting Oracle DB service: docker-compose up -d dbserver"
docker-compose up -d dbserver

echo "Checking Oracle DB health ... "

# invoke function check_database_health
check_database_health

echo "Oracle DB service is $DB_HEALTH"

if [[ "${DB_HEALTH}" != "\"healthy\"" ]]; then
  exit 1
fi

# Start application build service:
# ojdbc7.jar dependency will be installed in local maven repo.
# Application Source code will be built and the application will run against the Oracle DB

echo "Starting application build service: docker-compose up appserver"
docker-compose up appserver

# Checking existence of table app_server in Oracle DB created by the application
STATUS=`docker exec dbserver /workspace/check_oracle_table.sh`

if [[ $STATUS -eq 1 ]]; then
  exit 1
fi
# Cleaning the docker-compose resources
docker-compose down
