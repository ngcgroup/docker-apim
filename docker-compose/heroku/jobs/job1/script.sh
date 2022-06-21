#! /bin/bash
set -x
LOOP_COUNT=$1
echo "This Job will echo message $1 times"
bearer_token=$(curl -s -X POST 'https://iam.bhn.technology/auth/realms/master/protocol/openid-connect/token' \
     --data-urlencode "username=${KEYCLOAK_USER}" \
     --data-urlencode "password=${KEYCLOAK_PASSWORD}" \
     --data-urlencode 'grant_type=password' \
     --data-urlencode 'client_id=admin-cli' \
      | jq -r '.access_token')

export PATH=/opt/keycloak/bin:$PATH
iam_server=https://iam.bhn.technology/auth
session_config=/opt/scripts/kcadm.config 
kcadm.sh config credentials --server ${iam_server} --realm master --user ${KEYCLOAK_USER} --password ${KEYCLOAK_PASSWORD} --config /opt/scripts/kcadm.config      
kcadm.sh get realms --config $session_config  --server ${iam_server}
kcadm.sh create realms --config $session_config -s realm=apistudio -s enabled=true -o

curl -s -H "Authorization: Bearer $bearer_token" -X POST 'https://iam.bhn.technology/auth/admin/realms/apistudio/client-scopes' -d '{ "name": "default",  "protocol": "openid-connect"}' -H 'Content-Type: application/json'

kcadm.sh create clients --config $session_config -r apistudio -f - <apistudio-key-manager.bhn.json

# add service client role
kcadm.sh add-roles --config $session_config -r apistudio  --uusername service-account-apistudio-keymanager-client \
 --cclientid realm-management --rolename create-client --rolename manage-clients \
 --rolename query-clients --rolename view-clients

client_id=$(kcadm.sh get clients --config $session_config -r apistudio | jq '.[] | select ( .clientId == "apistudio-keymanager-client" ) | .id' -r)
secret=$(kcadm.sh get clients/$client_id/client-secret --config $session_config -r apistudio | jq '.value' -r)


for ((i=1;i<=$LOOP_COUNT;i++)); 
do
   sleep 2
   echo $i] Hey I will run till the job completes.
done

while [ true ]; do
	sleep 60;
done