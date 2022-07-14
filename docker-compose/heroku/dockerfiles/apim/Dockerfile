# ------------------------------------------------------------------------
#
# Copyright 2020 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
#
# ------------------------------------------------------------------------

# set base Docker image to WSO2 API Manager Docker image with latest WSO2 Updates
FROM wso2/wso2am:4.1.0-alpine

LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>"
USER root
RUN apk add --no-cache bash
ADD ./entrypoint.sh /home/wso2carbon/
RUN chmod a+x /home/wso2carbon/entrypoint.sh
USER wso2carbon

# build arguments for external artifacts
ARG MYSQL_CONNECTOR_VERSION=8.0.17
ARG POSTGRE_CONNECTOR_VERSION=42.3.6
ARG WSO2_HOME=/home/wso2carbon/wso2am-4.1.0
ARG WSO2_APP_HOME=${WSO2_HOME}/repository/deployment/server/jaggeryapps
ARG WSO2_DEVPORTAL_DIST=${WSO2_APP_HOME}/devportal/site/public/dist
ARG local=false
ADD --chown=wso2carbon:wso2 ./conf/apim /home/wso2carbon/wso2-config-volume
#ADD ./apps/deployment/server/jaggeryapps/devportal/site/public/dist/bundle.tar.gz ${WSO2_DEVPORTAL_DIST}/
#RUN tar -zxv -C ${WSO2_DEVPORTAL_DIST}/ -f /tmp/bundle.tar.gz && rm /tmp/bundle.tar.gz
USER root
RUN apk --no-cache add curl
RUN if [ "$local" = "true" ]; then mv /home/wso2carbon/wso2-config-volume/repository/conf/deployment.toml.local /home/wso2carbon/wso2-config-volume/repository/conf/deployment.toml && rm -f /home/wso2carbon/wso2-config-volume/repository/conf/deployment; fi
USER wso2carbon
#ADD client-truststore.jks ${WSO2_SERVER_HOME}/repository/resources/security/

# add MySQL JDBC connector to server home as a third party library
ADD --chown=wso2carbon:wso2 https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar ${WSO2_SERVER_HOME}/repository/components/dropins/
ADD --chown=wso2carbon:wso2 https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar ${WSO2_SERVER_HOME}/repository/components/lib/

ADD --chown=wso2carbon:wso2  https://jdbc.postgresql.org/download/postgresql-${POSTGRE_CONNECTOR_VERSION}.jar ${WSO2_SERVER_HOME}/repository/components/dropins/


ENTRYPOINT ["/home/wso2carbon/entrypoint.sh"]
