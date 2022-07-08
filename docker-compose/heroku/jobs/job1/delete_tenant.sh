#! /bin/bash
set -x

export PATH=/opt/keycloak/bin:$PATH
iam_server=${iam_server_without_auth}/auth
api_admin_server_host=apistudio.bhn.technology
api_admin_server_url=https://${api_admin_server_host}
api_realm=apistudio

cd /opt/scripts


## Adding WSO2 tenant setup

XML=$(cat auth.xml.template | sed "s/ADMIN_USER/${ADMIN_USER}/g" | sed "s/ADMIN_PASSWORD/${ADMIN_PASSWORD}/g" | sed "s/SERVER/${api_admin_server_host}/g")
COOKIE=$(curl -k -s -o /dev/null -D -  -H 'SOAPAction: urn:login' -H 'Content-Type: text/xml' -d "$XML" ${api_admin_server_url}/services/AuthenticationAdmin | grep set-cookie | cut -d':' -f2 | cut -d ';' -f1 | sed 's/^ //g')

tenant_domain=$1
XML=$(cat delete_tenant.xml.template | sed "s/DOMAIN/${tenant_domain}/g")
echo $XML
curl -kv -H 'Authorization: Basic $AUTH' -H "Cookie: $COOKIE" -H 'Content-Type: application/soap+xml;charset=UTF-8;action="urn:deleteTenant"' -d "$XML" -X POST ${api_admin_server_url}/services/TenantMgtAdminService.TenantMgtAdminServiceHttpsSoap12Endpoint
