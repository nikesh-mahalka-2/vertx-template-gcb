#!/bin/bash
VAR=1
while [[ $VAR != 0 ]]
do
  echo "checking existence of app_message"
  PGPASSWORD=test psql  -U test -d test -h dbserver.vertx-template-gcb_default -c "\d app_message"
  VAR=`echo $?`
  sleep 10
done
echo "app_message table is created"
