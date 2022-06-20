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
kcadm.sh config credentials --server ${iam_server} --realm master --user ${KEYCLOAK_USER} --password ${KEYCLOAK_PASSWORD} --config /opt/scripts/kcadm.config      
kcadm.sh get realms --config /opt/scripts/kcadm.config  --server ${iam_server}

for ((i=1;i<=$LOOP_COUNT;i++)); 
do
   sleep 2
   echo $i] Hey I will run till the job completes.
done

while [ true ]; do
	sleep 60;
done