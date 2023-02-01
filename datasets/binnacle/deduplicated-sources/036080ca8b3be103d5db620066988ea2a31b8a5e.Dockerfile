
FROM openjdk:8-jre-slim AS builder

MAINTAINER mark.prichard@appdynamics.com

ARG APPD_AGENT_VERSION 
ARG APPD_AGENT_SHA256

COPY MachineAgent-${APPD_AGENT_VERSION}.zip /
RUN if [ "x${APPD_AGENT_SHA256}" != "x" ]; then \ 
	echo "${APPD_AGENT_SHA256} *MachineAgent-${APPD_AGENT_VERSION}.zip" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && unzip -oq MachineAgent-${APPD_AGENT_VERSION}.zip -d /tmp; \
    else \
     unzip -oq MachineAgent-${APPD_AGENT_VERSION}.zip -d /tmp; \
    fi


FROM registry.access.redhat.com/rhel7/rhel

RUN yum install java-1.8.0-openjdk -y && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY --from=builder /tmp /opt/appdynamics

ENV MACHINE_AGENT_HOME /opt/appdynamics

WORKDIR ${MACHINE_AGENT_HOME}

COPY updateAnalyticsAgent.sh ./updateAnalyticsAgent.sh
RUN chmod +x ./updateAnalyticsAgent.sh

COPY startup.sh ./startup.sh
RUN chmod +x ./startup.sh


RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt

EXPOSE 9090

CMD "./startup.sh"