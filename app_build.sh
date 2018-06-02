#!/bin/bash
apt-get update
apt-get install curl -y
cd /workspace
mvn install:install-file -Dfile=./ojdbc7.jar -DgroupId=com.oracle.jdbc -DartifactId=ojdbc7 -Dversion=12.1.0.2 -Dpackaging=jar
mvn -DskipTests clean package
curl -sSL https://download.sourceclear.com/ci.sh | sh;
nohup java -Ddatabase.url=jdbc:oracle:thin:@dbserver:1521/ORCLCDB.localdomain -Djava.security.egd=file:/dev/./urandom -jar ./target/vertx-*-SNAPSHOT.jar create-database run 2>&1 &
