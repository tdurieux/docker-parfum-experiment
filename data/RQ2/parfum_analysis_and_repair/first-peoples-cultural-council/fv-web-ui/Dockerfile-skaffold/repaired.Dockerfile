FROM maven:3-openjdk-11 AS builder

COPY skaffold/dockerfiles/firstvoices/settings.xml .
RUN mkdir -p /root/.m2
RUN cat settings.xml > $HOME/.m2/settings.xml

RUN mkdir -p /opt/src && mkdir -p /opt/src/firstvoices-marketplace && mkdir -p /opt/src/modules
WORKDIR /opt/src

COPY pom.xml .
COPY modules modules
COPY firstvoices-marketplace firstvoices-marketplace

RUN ["/usr/local/bin/mvn-entrypoint.sh", "mvn", "install", "-DskipTests", "-T2C"]

FROM 482366472492.dkr.ecr.ca-central-1.amazonaws.com/nuxeo-base:2022-03-29

COPY skaffold/dockerfiles/firstvoices/setup.sh /docker-entrypoint-initnuxeo.d/setup.sh

COPY --from=builder opt/src/firstvoices-marketplace/target/firstvoices-marketplace-package-latest.zip /opt/nuxeo/server/tmp/