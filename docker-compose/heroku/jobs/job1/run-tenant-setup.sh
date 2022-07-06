#!/bin/bash


SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
COMMON_DIR=$SCRIPT_DIR/../../../../common/scripts

for i in $COMMON_DIR/*;
  do source $i
done

parse_args $@
export ENV_TENANT=$tenant
source_env_from_aws
set -x
namespace="api"
if [ "$cleanup" == "true" ]; then
	kubectl delete configmap env-bindings-cm-tenant -n $namespace
	kubectl delete jobs kubernetes-create-tenant-job -n $namespace
	exit
fi
set -e
kubectl create configmap env-bindings-cm-tenant --from-env-file=env-file -n $namespace
kubectl create  -f create_tenant.yaml $dry_run
sleep 10
kubectl logs -f $(kubectl get po -n api | grep kubernetes-create-tenant-job | grep 'Running' | awk '{print $1}') -n api
