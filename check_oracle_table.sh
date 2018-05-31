#!/bin/bash
STATUS="ERROR: ORA-"
num_retry=1
echo "Checking existence of table app_server in Oracle DB created by the application"
until [ $num_retry -gt $DB_TBL_CHK_MAX_RETRY ]
do
  STATUS=`/u01/app/oracle/product/12.2.0/dbhome_1/bin/sqlplus -S sys/Oradoc_db1@dbserver.workspace_default:1521/ORCLCDB.localdomain as sysdba << EOF
describe app_message
EOF`
  if [[ $STATUS =~ "ERROR: ORA-" ]]; then
    echo "app_message table creation status is: $STATUS"
    echo "retry-$num_retry to check app_message table creation status"
    num_retry=$[$num_retry+1]
    sleep $DB_TBL_CHK_SLEEP
  else
    break
done

echo "app_message table creation status is: $STATUS"
if [[ $STATUS =~ "ERROR: ORA-" ]]; then
  exit 1

exit 0
