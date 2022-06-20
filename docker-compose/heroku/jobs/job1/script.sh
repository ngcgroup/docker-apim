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

echo $bearer_token
for ((i=1;i<=$LOOP_COUNT;i++)); 
do
   sleep 2
   echo $i] Hey I will run till the job completes.
done
