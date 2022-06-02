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
export DATABASE_URL=postgres://pguser:${DB_PASS}@api-db:5432/apimgmt # api database url
export HEROKU_POSTGRESQL_YELLOW_URL=postgres://pguser:${DB_PASS}@shared-db:5432/shared  #shared database url
docker-compose -f docker-compose.yml -f docker-compose-as-postgre.yml up --build -d
