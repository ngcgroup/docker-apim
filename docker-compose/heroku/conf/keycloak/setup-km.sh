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

if [ "$REST_ADMIN_CLIENT_SECRET" == "" ]; then
	echo "missing key setup - initiating key setup";

	OUTPUT=`curl -s -X POST -H "Authorization: Basic $(echo $ADMIN_USER:$ADMIN_PASSWORD | base64)" -H "Content-Type: application/json"  \
		-d @payload.json https://apistudio2.herokuapp.com/client-registration/v0.17/register | jq .`
	REST_ADMIN_CLIENT_SECRET=$(echo $OUTPUT | jq .clientSecret --raw-output)
	heroku config:set REST_ADMIN_CLIENT_SECRET=$REST_ADMIN_CLIENT_SECRET --app apistudio2
	REST_ADMIN_CLIENT_ID=$(echo $OUTPUT | jq .clientId --raw-output)
	heroku config:set REST_ADMIN_CLIENT_ID=$REST_ADMIN_CLIENT_ID --app apistudio2

else
	echo "KEY FOUND"
fi

AUTH=$(echo $REST_ADMIN_CLIENT_ID:$REST_ADMIN_CLIENT_SECRET | openssl enc -a -A | tr -d '=' | tr '/+' '_-')
TOKEN_PAYLOAD=`curl -H "Authorization: Basic $AUTH" \
-d "grant_type=client_credentials&scope=apim:admin apim:tier_view" \
-s -X POST https://apistudio2.herokuapp.com/oauth2/token`
TOKEN=$(echo $TOKEN_PAYLOAD | jq .access_token --raw-output)
echo $TOKEN
curl -s  -H "Authorization: Bearer $TOKEN" https://apistudio2.herokuapp.com/api/am/admin/v3/key-managers | jq .

cat kc-km.json.template | sed "s/KC_APIM_CLIENT_SECRET/${KC_APIM_CLIENT_SECRET}/g" > kc-km.json
curl -s  -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d @kc-km.json -X POST https://apistudio2.herokuapp.com/api/am/admin/v3/key-managers

PIZZA_CLIENT_APPLICATION_ID=e83c6f43-8728-4713-bb8e-cf67e88fdc74
KEYMANAGERS=$(curl -s  -H "Authorization: Bearer $TOKEN" https://apistudio2.herokuapp.com/api/am/devportal/v2/applications/$PIZZA_CLIENT_APPLICATION_ID/oauth-keys)
CONSUMER_KEY=$(echo $KEYMANAGERS | jq '.list[] | select(.keyManager == "bhniam") | .consumerKey' --raw-output)
CONSUMER_SECRET=$(echo $KEYMANAGERS | jq '.list[] | select(.keyManager == "bhniam") | .consumerSecret' --raw-output)
CONSUMER_CLIENT_ID=$(echo $KEYMANAGERS | jq '.list[] | select(.keyManager == "bhniam") | .additionalProperties.client_id' --raw-output)
CONSUMER_CLIENT_SECRET=$(echo $KEYMANAGERS | jq '.list[] | select(.keyManager == "bhniam") | .additionalProperties.client_secret' --raw-output)
CONSUMER_AUTH=$(echo $CONSUMER_KEY:$CONSUMER_SECRET | openssl enc -a -A | tr -d '=' | tr '/+' '_-')
#CONSUMER_AUTH=$(echo $CONSUMER_KEY:$CONSUMER_SECRET | base64 -w 0)

API_ACCESS_TOKEN=$(curl -s -H "Authorization: Bearer $CONSUMER_AUTH"  -d "client_id=$CONSUMER_CLIENT_ID&client_secret=$CONSUMER_CLIENT_SECRET&grant_type=client_credentials" -X POST https://bhn-iam.herokuapp.com/auth/realms/apistudio2/protocol/openid-connect/token | jq .access_token --raw-output)
curl -s  -H "Authorization: Bearer $API_ACCESS_TOKEN" -H 'accept: application/json'   -H 'Content-Type: application/json' https://bhnapigw.herokuapp.com:443/pizzashack/1.0.0/menu
curl -s  -H "Authorization: Bearer $API_ACCESS_TOKEN" \
	-H 'accept: application/json'   -H 'Content-Type: application/json' \
 	-d '{"customerName": "string", "delivered": true, "address": "string", "pizzaType": "string", "creditCardNumber": "string","quantity": 0, "orderId": "string"}' \
 	-X POST https://bhnapigw.herokuapp.com:443/pizzashack/1.0.0/order

