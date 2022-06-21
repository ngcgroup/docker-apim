###### common stuff ####
#!/bin/bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
COMMON_DIR=$SCRIPT_DIR/../../../../common/scripts
set -x
for i in $COMMON_DIR/*;
  do source $i
done
set -x -e
parse_args $@
source_env_from_aws
###### common stuff ####

source env-file
api_admin_server=apistudio.bhn.technology

if [[ "$API_REST_ADMIN_CLIENT_SECRET" == "" || "$force" == "true" ]]; then
	echo "missing key setup - initiating key setup";

	OUTPUT=`curl -s -X POST -H "Authorization: Basic $(echo ${ADMIN_USER}:${ADMIN_PASSWORD} | openssl enc -a -A | tr -d '=' | tr '/+' '_-')" -H "Content-Type: application/json"  \
		-d @rest_admin_bootstrap_payload.json https://${api_admin_server}/client-registration/v0.17/register | jq .`
	API_REST_ADMIN_CLIENT_SECRET=$(echo $OUTPUT | jq .clientSecret --raw-output)
	API_REST_ADMIN_CLIENT_ID=$(echo $OUTPUT | jq .clientId --raw-output)
	aws ssm put-parameter \
	    --name "${app}API_REST_ADMIN_CLIENT_SECRET" \
	    --type "String" \
	    --value "${API_REST_ADMIN_CLIENT_SECRET}" \
	    --overwrite
	aws ssm put-parameter \
	    --name "${app}API_REST_ADMIN_CLIENT_ID" \
	    --type "String" \
	    --value "${API_REST_ADMIN_CLIENT_ID}" \
	    --overwrite
else
	echo "KEY FOUND $API_REST_ADMIN_CLIENT_ID: $API_REST_ADMIN_CLIENT_SECRET"
fi