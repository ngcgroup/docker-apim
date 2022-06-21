
#!/bin/bash
set -e
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
COMMON_DIR=$SCRIPT_DIR/../../common/scripts
echo $COMMON_DIR
for i in $COMMON_DIR/*;
  do source $i
done
set -x -e

registry=982306614752.dkr.ecr.us-west-2.amazonaws.com
image="wso2-apim:latest"
cd dockerfiles/apim
docker build -t $image .
docker tag $image $registry/$image
docker_login $registry
docker_push $registry/$image