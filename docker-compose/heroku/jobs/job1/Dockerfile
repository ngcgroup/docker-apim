FROM 982306614752.dkr.ecr.us-west-2.amazonaws.com/wso2-apim:latest
ARG USER=wso2carbon
ARG USER_HOME=/home/${USER}
ENV KEYCLOAK_VERSION 16.1.1
ARG KEYCLOAK_DIST=keycloak-$KEYCLOAK_VERSION.tar.gz
ADD --chown=wso2carbon:wso2 $KEYCLOAK_DIST /opt/
ADD --chown=wso2carbon:wso2 ./script.sh /opt/scripts/script.sh
ADD --chown=wso2carbon:wso2 ./*.json* /opt/scripts/

RUN  chmod -R g+rwX /opt/scripts/ && chown -R wso2carbon:wso2 /opt/scripts 
USER root
#RUN chmod -R g+rwX /opt/keycloak-$KEYCLOAK_VERSION && mkdir -p /opt/keycloak-$KEYCLOAK_VERSION/data 
RUN ln -s /opt/keycloak-$KEYCLOAK_VERSION /opt/keycloak
RUN apk --no-cache add curl jq openssl
USER ${USER}
ENTRYPOINT ["/opt/scripts/script.sh"]

