#!/bin/bash
set -e
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
COMMON_DIR=$SCRIPT_DIR/../../common/scripts
echo $COMMON_DIR
for i in $COMMON_DIR/*;
  do source $i
done
parse_args $@
source_env_from_aws


set -x -e
kubectl apply -k .
kubectl get secret keycloak-keystore --namespace=iam -o yaml | sed 's/namespace: iam/namespace: api/g' | kubectl apply -f -
