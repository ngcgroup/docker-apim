#!/bin/bash


SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
COMMON_DIR=$SCRIPT_DIR/../../../../common/scripts

for i in $COMMON_DIR/*;
  do source $i
done

parse_args $@
source_env_from_aws
set -x
namespace="api"
if [ "$cleanup" == "true" ]; then
	kubectl delete configmap env-bindings-cm-job1 -n $namespace
	kubectl delete jobs kubernetes-job-example -n $namespace
	exit
fi
set -e
kubectl create configmap env-bindings-cm-job1 --from-env-file=env-file -n $namespace
kubectl create  -f job.yaml $dry_run
kubectl logs -f $(kubectl get po -n api | grep kubernetes-job-example | awk '{print $1}') -n api
