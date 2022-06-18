#!/bin/bash
set -e
set -x

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--push)
        docker_push="true"
        shift # past argument
        #shift # past value
        ;; 
	-l|--login)
        docker_login="true"
        shift # past argument
        #shift # past value
        ;;                       
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

cd dockerfiles/apim
docker build -t wso2-apim .
docker tag wso2-apim:latest 982306614752.dkr.ecr.us-west-2.amazonaws.com/wso2-apim:latest

if [ "$docker_login" == "true" ];then
	aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 982306614752.dkr.ecr.us-west-2.amazonaws.com
fi

if [ "$docker_push" == "true" ];then
	docker push 982306614752.dkr.ecr.us-west-2.amazonaws.com/wso2-apim:latest
fi