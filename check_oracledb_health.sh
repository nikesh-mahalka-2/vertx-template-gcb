#!/bin/bash
set -xe
num_retry=0
until [[ $num_retry -gt $DB_HLTH_CHK_MAX_RETRY ]]
do
  echo "retry-$num_retry to check health of Oracle DB"
  DB_HEALTH="$(docker inspect --format='{{json .State.Health.Status}}' dbserver)"
  echo "Oracle DB is $DB_HEALTH"
  
	if [[ "${DB_HEALTH}" == "\"healthy\"" ]]; then
    break
	else
    num_retry=$[$num_retry+1]
  fi
  sleep $DB_HLTH_CHK_SLEEP
done

if [[ $num_retry -gt $DB_HLTH_CHK_MAX_RETRY ]]; then
  exit 1
fi
