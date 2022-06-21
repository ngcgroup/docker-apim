#! /bin/bash
set -x
LOOP_COUNT=$1
echo "This Job will echo message $1 times"


export PATH=/opt/keycloak/bin:$PATH
iam_host=iam.bhn.technology
iam_server=https://${iam_host}/auth
api_admin_server_host=apistudio.bhn.technology
api_admin_server_url=https://${api_admin_server_host}
session_config=/opt/scripts/kcadm.config 
api_realm=apistudio

## KEY MANAGER SETUP START ###
kc_km_client_id=apistudio-keymanager-client
cd /opt/scripts


### KC API REALM AND CLIENT SETUP ###
bearer_token=$(curl -s -X POST "${iam_server}/realms/master/protocol/openid-connect/token" \
     --data-urlencode "username=${KEYCLOAK_USER}" \
     --data-urlencode "password=${KEYCLOAK_PASSWORD}" \
     --data-urlencode 'grant_type=password' \
     --data-urlencode 'client_id=admin-cli' \
      | jq -r '.access_token')

kcadm.sh config credentials --server ${iam_server} --realm master --user ${KEYCLOAK_USER} --password ${KEYCLOAK_PASSWORD} --config /opt/scripts/kcadm.config      
#kcadm.sh get realms --config $session_config  --server ${iam_server}
kcadm.sh create realms --config $session_config -s realm=${api_realm} -s enabled=true -o

curl -s -H "Authorization: Bearer $bearer_token" -X POST "${iam_server}/admin/realms/${api_realm}/client-scopes" -d '{ "name": "default",  "protocol": "openid-connect"}' -H 'Content-Type: application/json'

cat apistudio-keymanager-client.json.template | sed "s/KC_KM_CLIENT_ID/${kc_km_client_id}/g" | sed "s/APISTUDIO_URL/${api_admin_server_host}/g" > apistudio-key-manager.bhn.json
kcadm.sh create clients --config $session_config -r ${api_realm} -f - < apistudio-key-manager.bhn.json

# add service client role
kcadm.sh add-roles --config $session_config -r ${api_realm}  --uusername service-account-${kc_km_client_id} \
 --cclientid realm-management --rolename create-client --rolename manage-clients \
 --rolename query-clients --rolename view-clients

# this is just the keycloak guid - not the client id ###
kc_id=$(kcadm.sh get clients --config $session_config -r ${api_realm} | jq ".[] | select ( .clientId == \"${kc_km_client_id}\" ) | .id" -r)
kc_km_client_secret=$(kcadm.sh get clients/${kc_id}/client-secret --config $session_config -r ${api_realm} | jq '.value' -r)


## WSO2 API KM SETUP ##
AUTH=$(echo $API_REST_ADMIN_CLIENT_ID:$API_REST_ADMIN_CLIENT_SECRET | base64)
TOKEN_PAYLOAD=$(curl -H "Authorization: Basic $AUTH" \
	-d "grant_type=client_credentials&scope=apim:admin apim:tier_view" \
	-s -X POST ${api_admin_server_url}/oauth2/token --http1.1)
TOKEN=$(echo $TOKEN_PAYLOAD | jq .access_token --raw-output)
echo $TOKEN

cat kc-km.json.template | sed "s/KC_KM_CLIENT_SECRET/${kc_km_client_secret}/g" \
	| sed "s/KC_KM_CLIENT_ID/${kc_km_client_id}/g" \
	| sed "s/APISTUDIO_URL/${iam_host}/g"  | sed "s/API_REALM/${api_realm}/g" > kc-km.json

curl -s  -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
	-d @kc-km.json -X POST ${api_admin_server_url}/api/am/admin/v3/key-managers


curl -s  -H "Authorization: Bearer $TOKEN" ${api_admin_server_url}/api/am/admin/v3/key-managers | jq .
### validation ###
./validate-km-setup.sh

## KEY MANAGER SETUP COMPLETE ###

for ((i=1;i<=$LOOP_COUNT;i++)); 
do
   sleep 2
   echo $i] Hey I will run till the job completes.
done

while [ true ]; do
	sleep 60;
done