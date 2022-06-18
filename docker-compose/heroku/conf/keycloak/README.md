

setting up KC as IS for WSO2
https://athiththan11.medium.com/wso2-api-manager-keycloak-sso-50bffa2353c7
https://is.docs.wso2.com/en/latest/develop/managing-tenants-with-apis/


https://medium.com/@naduni_pamudika/calling-wso2-admin-services-78afa7dd4c44
https://medium.com/@maheeka/wso2-admin-services-c61b7d856272

```bash

./get-wso2-admin-token.sh

#curl  -s  -H "Authorization: Bearer $TOKEN"  -H "accept: application/json" \
#-X GET "https://apistudio2.herokuapp.com/t/carbon.super/api/server/v1/tenants"

./add_tenant.sh -au $ADMIN_USER -ap $ADMIN_PASSWORD -tu partner4 -tp $ADMIN_PASSWORD -tf p4f1 -tl p4l1  -td partner4.com -te admin@partner4.com --server localhost --port 9443
```

https://athiththan11.medium.com/tenant-specific-devportal-publisher-service-providers-84d98c9458c6
