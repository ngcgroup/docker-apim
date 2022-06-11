#!/bin/bash
set -e 
set -x

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -au|--admin-user)
        admin_user="$2"
        shift # past argument
        shift # past value
        ;;
    -ap|--admin-password)
        admin_password="$2"
        shift # past argument
        shift # past value
        ;;
    -s|--server)
        server="$2"
        shift # past argument
        shift # past value
        ;;
    -p|--port)
        port="$2"
        shift # past argument
        shift # past value
        ;;        
    -tu|--tenant-user)
        tenant_user="$2"
        shift # past argument
        shift # past value
        ;;
    -tp|--tenant-password)
        tenant_password="$2"
        shift # past argument
        shift # past value
        ;; 
    -tf|--tenant-firstname)
        tenant_firstname="$2"
        shift # past argument
        shift # past value
        ;;  
    -tl|--tenant-lastname)
        tenant_lastname="$2"
        shift # past argument
        shift # past value
        ;; 
    -td|--tenant-domain)
        tenant_domain="$2"
        shift # past argument
        shift # past value
        ;;    
    -te|--tenant-email)
        tenant_email="$2"
        shift # past argument
        shift # past value
        ;;                        
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

echo $admin_user $admin_password $tenant_user $tenant_password $tenant_firstname $tenant_lastname $tenant_domain $tenant_email


AUTH=$(echo $admin_user:$admin_password | base64)
XML=$(cat auth_template.xml | sed "s/ADMIN_USER/${admin_user}/g" | sed "s/ADMIN_PASSWORD/${admin_password}/g" | sed "s/SERVER/${server}/g")
COOKIE=$(curl -k -s -o /dev/null -D -  -H 'SOAPAction: urn:login' -H 'Content-Type: text/xml' -d "$XML" https://$server:$port/services/AuthenticationAdmin | grep Cookie | cut -d':' -f2 | cut -d ';' -f1 | sed 's/^ //g')
XML=$(cat add_tenant_template.xml | sed "s/USERNAME/${tenant_user}/g" | sed "s/PASSWORD/${tenant_password}/g" |sed "s/EMAIL/${tenant_email}/g"  | sed "s/SERVER/${server}/g" | sed "s/DOMAIN/${tenant_domain}/g" | sed "s/FIRSTNAME/${tenant_firstname}/g" | sed "s/LASTNAME/${tenant_lastname}/g" | sed "s/EMAIL/${tenant_email}/g"  )
echo $XML
curl -kv -H 'Authorization: Basic $AUTH' -H "Cookie: $COOKIE" -H 'Content-Type: application/soap+xml;charset=UTF-8;action="urn:addTenant"' -d "$XML" -X POST https://$server:$port/services/TenantMgtAdminService.TenantMgtAdminServiceHttpsSoap12Endpoint


