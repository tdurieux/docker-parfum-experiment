#FROM payara/server-full:5.201
FROM payara/micro:5.201
#FROM payara/micro:5.194

# Imixs-Microservice Version payara-micro
MAINTAINER ralph.soika@imixs.com

# add configuration files
USER root
RUN mkdir ${PAYARA_HOME}/config
# Copy domain.xml
COPY ./src/docker/conf/payara-micro/domain.xml ${PAYARA_HOME}/config/
COPY ./src/docker/conf/payara-micro/keyfile ${PAYARA_HOME}/config/
# Deploy artefacts
COPY ./src/docker/conf/payara-micro/postgresql-42.2.5.jar ${PAYARA_HOME}/config
COPY ./src/docker/apps/* $DEPLOY_DIR

RUN chown -R payara:payara ${PAYARA_HOME}/config
USER payara
WORKDIR ${PAYARA_HOME}

# add lauch options