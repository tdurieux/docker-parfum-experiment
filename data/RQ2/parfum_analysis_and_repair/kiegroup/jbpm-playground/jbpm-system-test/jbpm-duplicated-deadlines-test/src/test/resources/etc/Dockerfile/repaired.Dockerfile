# Multi-stage Dockerfile

# First, build kjar from a maven image

ARG IMAGE_NAME

FROM maven:3.6.3-openjdk-8-slim as builder
LABEL autodelete="true"
COPY etc/kjars/ /etc/kjars/
RUN mvn --file /etc/kjars/deadline-sample/pom.xml --batch-mode clean install -DskipTests
RUN mvn --file /etc/kjars/no-notif-sample/pom.xml --batch-mode clean install -DskipTests

#########################################################
# Dockerfile that provides the image for KIE Server
#########################################################