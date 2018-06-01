#!/bin/bash
set -xe
num_retry=1
until [ $num_retry -gt $DB_HLTH_CHK_MAX_RETRY ]
do
  DB_HEALTH="$(docker inspect --format='{{json .State.Health.Status}}' dbserver)"
	if [[ "${DB_HEALTH}" == "\"healthy\"" ]]; then
    echo "Oracle DB is $DB_HEALTH"
    break
	else
    echo "Oracle DB is $DB_HEALTH"
	  echo "retry-$num_retry to check health of Oracle DB"
	  num_retry=$[$num_retry+1]
  fi
  sleep $DB_HLTH_CHK_SLEEP
done
