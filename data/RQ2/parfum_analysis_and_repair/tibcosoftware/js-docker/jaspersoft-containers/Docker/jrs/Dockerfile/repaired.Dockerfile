# Copyright (c) 2021-2021. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file

#ARG TOMCAT_BASE_IMAGE=tomcat:9.0.54-jdk11-corretto
ARG TOMCAT_BASE_IMAGE=tomcat:9.0.54-jdk11-openjdk
ARG INSTALL_CHROMIUM=false
ARG JASPERREPORTS_SERVER_VERSION=8.0.2

FROM ${TOMCAT_BASE_IMAGE} as deployment

ARG JASPERREPORTS_SERVER_VERSION
ARG INSTALL_CHROMIUM
ARG CONTAINER_DISTRO=jaspersoft-containers/Docker/jrs
ARG JRS_DISTRO=jasperreports-server-pro-${JASPERREPORTS_SERVER_VERSION}-bin


ENV INSTALL_CHROMIUM ${INSTALl_CHROMIUM:-false}
ENV JASPERREPORTS_SERVER_VERSION ${JASPERREPORTS_SERVER_VERSION:-8.0.2}
ENV JRS_HOME /usr/src/jasperreports-server
ENV BUILDOMATIC_MODE non-interactive

COPY ${JRS_DISTRO}/buildomatic ${JRS_HOME}/buildomatic/
COPY ${JRS_DISTRO}/apache-ant ${JRS_HOME}/apache-ant/
COPY ${JRS_DISTRO}/jasperserver-pro.war  ${JRS_HOME}/
COPY ${CONTAINER_DISTRO}/resources/buildomatic-customization ${JRS_HOME}/buildomatic/
COPY ${CONTAINER_DISTRO}/resources/default-properties ${JRS_HOME}/buildomatic/
COPY ${CONTAINER_DISTRO}/resources/keystore /usr/local/share/jasperserver-pro/keystore
COPY ${CONTAINER_DISTRO}/scripts/installPackagesForJasperserver-pro.sh /usr/local/scripts/installPackagesForJasperserver-pro.sh

RUN chmod +x /usr/src/jasperreports-server/buildomatic/js-* && \
        chmod +x /usr/src/jasperreports-server/apache-ant/bin/* &&\
        chmod +x /usr/local/scripts/*.sh && \
        /usr/local/scripts/installPackagesForJasperserver-pro.sh &&\
        rm -rf $CATALINA_HOME/webapps/ROOT && \
        rm -rf $CATALINA_HOME/webapps/docs && \
        rm -rf $CATALINA_HOME/webapps/examples && \
        rm -rf $CATALINA_HOME/webapps/host-manager && \
        rm -rf $CATALINA_HOME/webapps/manager

RUN useradd -m jasperserver -u 10099 && chown -R jasperserver:root $CATALINA_HOME &&\
                            chown -R jasperserver:root ${JRS_HOME} &&\
                            chown -R jasperserver:root /usr/local/share/jasperserver-pro/keystore
#USER jasperserver
WORKDIR ${JRS_HOME}/buildomatic/
RUN ./js-ant test-pro-all-props check-dbtype-pro test-appServerType-pro deploy-webapp-pro-if-needed
#set-minimal-mode gen-config pre-install-test-pro prepare-js-pro-db-minimal