#!/bin/bash
apt-get update
apt-get install curl -y
cd /workspace
mvn install:install-file -Dfile=./ojdbc7.jar -DgroupId=com.oracle.jdbc -DartifactId=ojdbc7 -Dversion=12.1.0.2 -Dpackaging=jar
mvn -DskipTests clean package
curl -sSL https://download.sourceclear.com/ci.sh | sh;
