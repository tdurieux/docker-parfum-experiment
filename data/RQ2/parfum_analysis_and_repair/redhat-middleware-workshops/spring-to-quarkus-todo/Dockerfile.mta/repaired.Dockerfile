# Dockerfile used to create the MTA CLI used in this exercise
# https://quay.io/repository/edeandrea/mta-cli
FROM registry.redhat.io/ubi8/openjdk-11-runtime:latest

ENV MTA_VERSION="5.3.0.Final"
ENV MTA_BASE_DIR="/opt/mta"
ENV MTA_NAME="mta-cli-${MTA_VERSION}"
ENV PROJECT_DIR="/opt/project"
ENV OUTPUT_DIR="mta-report"
ENV MTA_HOME="${MTA_BASE_DIR}/${MTA_NAME}"
ENV PACKAGE_NAME="com.acme"

VOLUME [${PROJECT_DIR}]

USER root

RUN mkdir -p ${MTA_BASE_DIR} && \
    cd ${MTA_BASE_DIR} && \
    curl -f -L -O https://repo1.maven.org/maven2/org/jboss/windup/mta-cli/${MTA_VERSION}/${MTA_NAME}-offline.zip && \
    unzip ${MTA_NAME}-offline.zip && \
    rm ${MTA_NAME}-offline.zip && \
    chown -R jboss:0 /opt && \
    chmod -R a+rwx /opt

USER jboss

RUN mkdir -p $HOME/.mta/ignore && \
    echo "target" >> $HOME/.mta/ignore/project.mta-ignore.txt

WORKDIR ${PROJECT_DIR}

CMD ${MTA_HOME}/bin/mta-cli --sourceMode --input . --output ${OUTPUT_DIR} --target quarkus --packages ${PACKAGE_NAME} --overwrite --explodedApp
