#!/bin/bash

TEMPIFS=$IFS; 
IFS=$'\n'; 
for var in $(heroku config -a apistudio2 | grep -v "apistudio2 Config Vars"); do 
	line=`echo $var | sed -e "s/:[[:space:]+]/=/g" | sed -e "s/[[:space:]+]//g"`; 
	if [[ "$line" =~ ^([a-zA-Z0-9_]*)=(.*)$ ]]; then 
		export ${BASH_REMATCH[1]}=${BASH_REMATCH[2]}; 
	fi; 
done; 
IFS=$TEMPIFS;
docker-compose -f docker-compose-as-postgre.yml up -d
PGPASSWORD=$DB_PASS psql -h $DOCKHERO_HOST -U pguser -p 5432 -d shared < ../../dbscripts/postgresql.sql
PGPASSWORD=$DB_PASS psql -h $DOCKHERO_HOST -U pguser -p 6432 -d apimgmt < ../../dbscripts/apimgt/postgresql.sql

docker-compose -f docker-compose-as-postgre.yml down
docker-compose -f docker-compose.yml -f docker-compose-as-postgre.yml up  --build -d
