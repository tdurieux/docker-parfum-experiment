ARG KEYCLOAK_VERSION="12.0.4"

FROM maven:3.6.3-jdk-8-slim AS keycloak-modules-builder

RUN apt -y -qq update && apt -y --no-install-recommends -qq install build-essential && rm -rf /var/lib/apt/lists/*;

RUN mkdir /deployments

ADD oisp-event-listener /modules/oisp-event-listener
ADD oisp-js-policies /modules/oisp-js-policies

WORKDIR /modules/oisp-event-listener
RUN mvn checkstyle:check pmd:check clean package
RUN cp /modules/oisp-event-listener/target/oisp-event-listener.jar /deployments/oisp-event-listener.jar

WORKDIR /modules/oisp-js-policies
RUN mvn clean package
RUN cp /modules/oisp-js-policies/target/oisp-js-policies.jar /deployments/oisp-js-policies.jar

FROM node:12-alpine AS keycloak-themes-builder

ADD themes /themes

WORKDIR /themes/fusion/login/resources
RUN npm install && npm cache clean --force;

FROM jboss/keycloak:${KEYCLOAK_VERSION}

RUN mkdir /opt/jboss/keycloak/realms
ADD --chown=1000 ./oisp-realm.json /opt/jboss/keycloak/realms/oisp-realm.json
ADD --chown=1000 ./service-accounts.json /opt/jboss/keycloak/realms/service-accounts.json
ADD --chown=1000 ./prepare-startup.sh /opt/jboss/keycloak/realms/prepare-realm.sh
ADD --chown=1000 ./migrate-realm.sh /opt/jboss/keycloak/realms/migrate-realm.sh

COPY --from=keycloak-modules-builder --chown=1000 /deployments /opt/jboss/keycloak/standalone/deployments
COPY --from=keycloak-themes-builder --chown=1000 /themes/fusion /opt/jboss/keycloak/themes/fusion
