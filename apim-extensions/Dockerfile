FROM maven:3.6.0-jdk-11-slim AS build
COPY custom-jwt-generator/src /home/app/custom-jwt-generator/src
COPY custom-jwt-generator/pom.xml /home/app/custom-jwt-generator/
RUN cd /home/app/custom-jwt-generator && mvn clean package

COPY custom-token-extractor/src /home/app/custom-token-extractor/src
COPY custom-token-extractor/pom.xml /home/app/custom-token-extractor/
RUN cd /home/app/custom-token-extractor && mvn clean package