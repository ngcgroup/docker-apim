#!/bin/bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
COMMON_DIR=$SCRIPT_DIR/../../../../common/scripts

for i in $COMMON_DIR/*;
  do source $i
done
set -x -e
registry=982306614752.dkr.ecr.us-west-2.amazonaws.com
parse_args $@
docker build . -t wso2-bootstrap-job
docker tag wso2-bootstrap-job $registry/wso2-bootstrap-job:latest
docker_login $registry
docker_push $registry/wso2-bootstrap-job:latest