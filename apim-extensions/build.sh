#!/usr/bin/env bash

docker build -t apim-extensions .
docker create --name extract apim-extensions
docker cp extract:/home/app/custom-jwt-generator/target/custom-jwt-generator-1.0-SNAPSHOT.jar ../docker-compose/heroku/dockerfiles/apim/conf/apim/repository/components/dropins
docker cp extract:/home/app/custom-token-extractor/target/custom-token-extractor-1.0-SNAPSHOT.jar ../docker-compose/heroku/dockerfiles/apim/conf/apim/repository/components/dropins
docker rm extract