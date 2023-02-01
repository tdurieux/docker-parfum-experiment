ARG KEYCLOAK_VERSION=18.0.2

FROM quay.io/keycloak/keycloak:$KEYCLOAK_VERSION-legacy

USER root

# Update OS packages
RUN true \
    && microdnf clean all \
    && microdnf install zip \
    && microdnf update --nodocs \
    && microdnf clean all \
    && true

# Mitigate lo4j 1.x CVEs
RUN echo Mitigating log4j CVEs && \
# https://www.cvedetails.com/cve/CVE-2022-23307/
# https://access.redhat.com/security/cve/cve-2022-23307
 echo Mitigating Log4j CVE: CVE-2022-23307 && \
 zip -q -d $JBOSS_HOME/modules/system/layers/base/org/jboss/log4j/logmanager/main/log4j-jboss-logmanager-*.Final.jar org/apache/log4j/chainsaw/* && \
 echo Mitigating Log4j CVE: CVE-2022-23302 && \
# https://www.cvedetails.com/cve/CVE-2022-23302/ && \
 zip -q -d $JBOSS_HOME/modules/system/layers/base/org/jboss/log4j/logmanager/main/log4j-jboss-logmanager-*.Final.jar org/apache/log4j/net/JMSAppender.class && \
 zip -q -d $JBOSS_HOME/modules/system/layers/base/org/jboss/log4j/logmanager/main/log4j-jboss-logmanager-*.Final.jar org/apache/log4j/net/JMSSink.class && \
 echo Mitigating Log4j CVE: CVE-2022-23305 && \
# https://www.cvedetails.com/cve/CVE-2022-23305/
 zip -q -d $JBOSS_HOME/modules/system/layers/base/org/jboss/log4j/logmanager/main/log4j-jboss-logmanager-*.Final.jar org/apache/log4j/jdbc/* && \
 echo Mitigating Log4j CVEs completed.

USER jboss

# Add custom Startup-Scripts
COPY --chown=jboss:root maven/cli/ /opt/jboss/startup-scripts

# Add feature configuration
COPY --chown=jboss:root maven/config/ /opt/jboss/keycloak/standalone/configuration/

# Add Keycloak Extensions
COPY --chown=jboss:root maven/extensions/ /opt/jboss/keycloak/standalone/deployments

# Add custom Theme
COPY --chown=jboss:root maven/themes/apps/ /opt/jboss/keycloak/themes/apps
COPY --chown=jboss:root maven/themes/internal/ /opt/jboss/keycloak/themes/internal