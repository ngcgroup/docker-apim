## enable keycloak operator on keycloak cluster to manage 
Install on Kubernetes. Install Operator Lifecycle Manager (OLM), a tool to help manage the Operators running on your cluster.

```bash # NOT USED
# install OLM
$ curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.21.2/install.sh | bash -s v0.21.2
#Copy to Clipboard
#Install the operator by running the following command:What happens when I execute this command?

$  NAMESPACE="keycloak-operator"; curl -sSL https://operatorhub.io/install/keycloak-operator.yaml | sed "s/my-keycloak-operator/$NAMESPACE/g" | kubectl apply -f - -n $NAMESPACE
# Copy to Clipboard
# This Operator will be installed in the "my-keycloak-operator" namespace and will be usable from this namespace only.

# After install, watch your operator come up using next command.

$ kubectl get csv -n $NAMESPACE
#Copy to Clipboard
#To use it, checkout the custom resource definitions (CRDs) introduced by this operator to start using it.
#$ kubectl apply -f keycloak-register.yaml
#$ kubectl create secret generic credential-iam-keycloak-ops \
#  --from-literal=username=$KEYCLOAK_USER \
#  --from-literal=password=$KEYCLOAK_PASSWORD -n iam
````
## manage keycloak with command line ##

```bash

$ alias kcadm="docker run -v ${PWD}/kcadm.config:/opt/keycloak/tools/kcadm.config --entrypoint /opt/jboss/keycloak/bin/kcadm.sh -it 982306614752.dkr.ecr.us-west-2.amazonaws.com/keycloak:latest"



$ $(profile=architecture; app='/arch/bhn/iam/'; app2=$(echo $app | sed 's/\//\\\//g'); aws ssm get-parameters-by-path --profile ${profile} --path $app --query "Parameters[*].{Name:Name,Value:Value}" | jq -r '.[] |[.Name, .Value] | @tsv' | sed "s/${app2}//g" | sed "s/^\///g" |awk -F '\t' '{print "export " $1"="$2}')
$ touch ./kcadm.config

# docker login
$ aws ecr get-login-password --profile architecture | docker login --username AWS --password-stdin 982306614752.dkr.ecr.us-west-2.amazonaws.com
# keycloak admin auth
$ kcadm config credentials --server https://iam.bhn.technology/auth --realm master --user ${KEYCLOAK_USER} --password ${KEYCLOAK_PASSWORD} --config /opt/keycloak/tools/kcadm.config


$ bearer_token=$(curl -X POST 'https://iam.bhn.technology/auth/realms/master/protocol/openid-connect/token' \
     --data-urlencode "username=${KEYCLOAK_USER}" \
     --data-urlencode "password=${KEYCLOAK_PASSWORD}" \
     --data-urlencode 'grant_type=password' \
     --data-urlencode 'client_id=admin-cli' \
      | jq -r '.access_token')
#keycloak realm creation
$ kcadm create realms -s realm=demorealm -s enabled=true -o --config /opt/keycloak/tools/kcadm.config

$ kcadm create clients --config /opt/keycloak/tools/kcadm.config -r demorealm -f my_client.json -s clientId=my_client2 -s 'redirectUris=["http://localhost:8980/myapp/*"]' -i
$ kubectl logs -f $(kubectl get po -n api | grep kubernetes-job-example | awk '{print $1}') -n api
```


### related links
1. https://www.keycloak.org/getting-started/getting-started-operator-kubernetes
2. https://operatorhub.io/operator/keycloak-operator
3. https://www.keycloak.org/docs/latest/server_installation/
4. https://apim.docs.wso2.com/en/latest/administer/key-managers/configure-keycloak-connector/
5. https://www.chakray.com/how-use-keycloak-as-wso2-api-manager-identity-provider/
6. https://github.com/wso2/product-is/blob/58914c08d563df3d8997dd15cc74c95641f02e68/modules/integration/tests-integration/tests-backend/src/test/java/org/wso2/identity/integration/test/utils/IdentityConstants.java
7. https://github.com/wso2/carbon-identity-framework/blob/cf4937895f3eaf7c96b20ca379dc741dc62dfbce/components/idp-mgt/org.wso2.carbon.idp.mgt/src/main/java/org/wso2/carbon/idp/mgt/dao/IdPManagementDAO.java
