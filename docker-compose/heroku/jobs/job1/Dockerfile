FROM 982306614752.dkr.ecr.us-west-2.amazonaws.com/wso2-apim:latest
USER root
RUN  apk --no-cache --update add curl jq openssl yq python3 py-pip
RUN pip install --upgrade --force-reinstall pip==9.0.3 && pip3 install yq && pip install --upgrade pip
ARG USER=wso2carbon
ARG USER_HOME=/home/${USER}
ENV KEYCLOAK_VERSION 16.1.1
ARG KEYCLOAK_DIST=keycloak-$KEYCLOAK_VERSION.tar.gz
USER ${USER}
ADD --chown=wso2carbon:wso2 $KEYCLOAK_DIST /opt/
ADD --chown=wso2carbon:wso2 ./script.sh /opt/scripts/script.sh
ADD --chown=wso2carbon:wso2 ./validate-km-setup.sh /opt/scripts/validate-km-setup.sh
ADD --chown=wso2carbon:wso2 ./*.json /opt/scripts/
ADD --chown=wso2carbon:wso2 ./*.template /opt/scripts/

#RUN  chmod -R g+rwX /opt/scripts/ && chown -R wso2carbon:wso2 /opt/scripts 
USER root
#RUN chmod -R g+rwX /opt/keycloak-$KEYCLOAK_VERSION && mkdir -p /opt/keycloak-$KEYCLOAK_VERSION/data 
RUN ln -s /opt/keycloak-$KEYCLOAK_VERSION /opt/keycloak
#RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
USER ${USER}
ENTRYPOINT ["/opt/scripts/script.sh"]

