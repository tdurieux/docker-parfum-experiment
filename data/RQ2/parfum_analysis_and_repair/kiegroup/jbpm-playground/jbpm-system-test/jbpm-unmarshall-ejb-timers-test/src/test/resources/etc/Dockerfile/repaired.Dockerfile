# Multi-stage Dockerfile

# First, build kjar from a maven image

ARG IMAGE_NAME

FROM maven:3.6.3-openjdk-8-slim as builder
LABEL autodelete="true"
COPY etc/kjars/ /etc/kjars/
RUN mvn --file /etc/kjars/unmarshall-ejb-sample/pom.xml --batch-mode install -DskipTests

#########################################################
# Dockerfile that provides the image for KIE Server
#########################################################