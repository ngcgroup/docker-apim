#!/bin/bash

export PATH=/opt/keycloak/bin:$PATH
iam_host=iam.bhn.technology
iam_server=https://${iam_host}/auth
api_admin_server_host=apistudio.bhn.technology
api_admin_server_url=https://${api_admin_server_host}
session_config=/opt/scripts/kcadm.config 
api_realm=apistudio
api_gw_url=https://apigw.bhn.technology

AUTH=$(echo $API_REST_ADMIN_CLIENT_ID:$API_REST_ADMIN_CLIENT_SECRET | base64)
TOKEN_PAYLOAD=$(curl -H "Authorization: Basic $AUTH" \
	-d "grant_type=client_credentials&scope=apim:admin apim:tier_view" \
	-s -X POST ${api_admin_server_url}/oauth2/token --http1.1)
TOKEN=$(echo $TOKEN_PAYLOAD | jq .access_token --raw-output)
echo $TOKEN
PIZZA_CLIENT_APPLICATION_ID=$(curl -s  -H "Authorization: Bearer $TOKEN"  ${api_admin_server_url}/api/am/devportal/v2/applications/ \
	| jq '.list | .[] | select(.name == "pizza") | .applicationId' -r)

KEYMANAGERS=$(curl -s  -H "Authorization: Bearer $TOKEN" \
	${api_admin_server_url}/api/am/devportal/v2/applications/$PIZZA_CLIENT_APPLICATION_ID/oauth-keys)
CONSUMER_KEY=$(echo $KEYMANAGERS | jq '.list[] | select(.keyManager == "bhniam") | .consumerKey' --raw-output)
CONSUMER_SECRET=$(echo $KEYMANAGERS | jq '.list[] | select(.keyManager == "bhniam") | .consumerSecret' --raw-output)
CONSUMER_CLIENT_ID=$(echo $KEYMANAGERS | jq '.list[] | select(.keyManager == "bhniam") | .additionalProperties.client_id' --raw-output)
CONSUMER_CLIENT_SECRET=$(echo $KEYMANAGERS | jq '.list[] | select(.keyManager == "bhniam") | .additionalProperties.client_secret' --raw-output)
CONSUMER_AUTH=$(echo $CONSUMER_KEY:$CONSUMER_SECRET | openssl enc -a -A | tr -d '=' | tr '/+' '_-')


API_ACCESS_TOKEN=$(curl -s -H "Authorization: Bearer $CONSUMER_AUTH" \
 	-d "client_id=$CONSUMER_CLIENT_ID&client_secret=$CONSUMER_CLIENT_SECRET&grant_type=client_credentials" \
  	-X POST ${iam_server}/realms/${api_realm}/protocol/openid-connect/token | \
  	jq .access_token --raw-output)
curl -s  -H "Authorization: Bearer $API_ACCESS_TOKEN" -H 'accept: application/json' \
	 -H 'Content-Type: application/json' ${api_gw_url}/pizzashack/1.0.0/menu | jq .

