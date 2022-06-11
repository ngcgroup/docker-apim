#!/bin/bash
set -e
TEMPIFS=$IFS; 
IFS=$'\n'; 
for var in $(heroku config -a apistudio2 | grep -v "apistudio2 Config Vars"); do 
	line=`echo $var | sed -e "s/:[[:space:]+]/=/g" | sed -e "s/[[:space:]+]//g"`; 
	if [[ "$line" =~ ^([a-zA-Z0-9_]*)=(.*)$ ]]; then 
		export ${BASH_REMATCH[1]}=${BASH_REMATCH[2]}; 
	fi; 
done; 
IFS=$TEMPIFS;
set -x

#REST_ADMIN_CLIENT_SECRET=$(heroku config:get REST_ADMIN_CLIENT_SECRET --app apistudio2)
TOKEN_TYPE=$1


	#AUTH=$(echo $REST_ADMIN_CLIENT_ID:$REST_ADMIN_CLIENT_SECRET | openssl enc -a -A | tr -d '=' | tr '/+' '_-')
AUTH=$(echo $ADMIN_USER:$ADMIN_PASSWORD | base64)
if [ "$TOKEN_TYPE" == "identity"  ]; then
	if [ "$REST_ADMIN_ID_CLIENT_SECRET" == "" ] ; then
		echo "missing IDENTITY TOKEN setup - initiating key setup";
		OUTPUT=`curl -s -X POST -H "Authorization: Basic $AUTH" -H "Content-Type: application/json"  \
			-d @payload-identity.json https://apistudio2.herokuapp.com/api/identity/oauth2/dcr/v1.1/register | jq .`
		REST_ADMIN_CLIENT_SECRET=$(echo $OUTPUT | jq .client_secret --raw-output)
		REST_ADMIN_CLIENT_ID=$(echo $OUTPUT | jq .client_id --raw-output)
		heroku config:set REST_ADMIN_ID_CLIENT_SECRET=$REST_ADMIN_CLIENT_SECRET --app apistudio2
		heroku config:set REST_ADMIN_ID_CLIENT_ID=$REST_ADMIN_CLIENT_ID --app apistudio2
	fi
else
	if [ "$REST_ADMIN_CLIENT_SECRET" == "" ]; then
		echo "missing ADMIN KEY setup - initiating key setup";
		OUTPUT=`curl -s -X POST -H "Authorization: Basic $(echo $ADMIN_USER:$ADMIN_PASSWORD | base64)" -H "Content-Type: application/json"  \
		-d @payload.json https://apistudio2.herokuapp.com/client-registration/v0.17/register | jq .`
		REST_ADMIN_CLIENT_SECRET=$(echo $OUTPUT | jq .clientSecret --raw-output)
		REST_ADMIN_CLIENT_ID=$(echo $OUTPUT | jq .clientId --raw-output)
		heroku config:set REST_ADMIN_CLIENT_SECRET=$REST_ADMIN_CLIENT_SECRET --app apistudio2
		heroku config:set REST_ADMIN_CLIENT_ID=$REST_ADMIN_CLIENT_ID --app apistudio2
	fi

fi




AUTH=$(echo $REST_ADMIN_CLIENT_ID:$REST_ADMIN_CLIENT_SECRET | openssl enc -a -A | tr -d '=' | tr '/+' '_-')
TOKEN_PAYLOAD=`curl -H "Authorization: Basic $AUTH" \
-d "grant_type=client_credentials&scope=apim:admin apim:tier_view SYSTEM" \
-s -X POST https://apistudio2.herokuapp.com/oauth2/token`
TOKEN=$(echo $TOKEN_PAYLOAD | jq .access_token --raw-output)
echo $TOKEN

