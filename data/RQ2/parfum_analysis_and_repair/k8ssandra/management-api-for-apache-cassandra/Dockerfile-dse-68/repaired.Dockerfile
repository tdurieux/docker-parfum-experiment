ARG CASSANDRA_VERSION=6.8.9

FROM maven:3.6.3-jdk-8-slim as builder

ARG METRICS_COLLECTOR_VERSION=0.2.0
ARG CDC_AGENT_VERSION=2.0.0
ARG CDC_AGENT_EDITION=agent-dse4

WORKDIR /build

COPY pom.xml ./
COPY management-api-agent-common/pom.xml ./management-api-agent-common/pom.xml
COPY management-api-agent-3.x/pom.xml ./management-api-agent-3.x/pom.xml
COPY management-api-agent-4.x/pom.xml ./management-api-agent-4.x/pom.xml
COPY management-api-agent-dse-6.8/pom.xml ./management-api-agent-dse-6.8/pom.xml
COPY management-api-common/pom.xml ./management-api-common/pom.xml
COPY management-api-server/pom.xml ./management-api-server/pom.xml
COPY settings.xml settings.xml /root/.m2/
# this duplicates work done in the next steps, but this should provide
# a solid cache layer that only gets reset on pom.xml changes
RUN mvn -q -ff -T 1C install -Pdse -DskipOpenApi && rm -rf target

COPY management-api-agent-common ./management-api-agent-common
COPY management-api-agent-3.x ./management-api-agent-3.x
COPY management-api-agent-4.x ./management-api-agent-4.x
COPY management-api-agent-dse-6.8 ./management-api-agent-dse-6.8
COPY management-api-common ./management-api-common
COPY management-api-server ./management-api-server
RUN mvn -q -ff package -DskipTests -Pdse

# Download CDC agent
ENV CDC_AGENT_PATH /opt/cdc_agent
RUN mkdir ${CDC_AGENT_PATH} && \
  curl -f -L -O "https://github.com/datastax/cdc-apache-cassandra/releases/download/v${CDC_AGENT_VERSION}/${CDC_AGENT_EDITION}-${CDC_AGENT_VERSION}-all.jar" && \
  mv ${CDC_AGENT_EDITION}-${CDC_AGENT_VERSION}-all.jar ${CDC_AGENT_PATH}/cdc-agent.jar


FROM datastax/dse-server:${CASSANDRA_VERSION}

# accept the License
ENV DS_LICENSE=accept

ENV CASSANDRA_PATH /opt/dse
ENV MAAC_PATH /opt/management-api
ENV CDC_AGENT_PATH /opt/cdc_agent


ENV CASSANDRA_HOME ${CASSANDRA_PATH}
ENV CASSANDRA_CONF ${CASSANDRA_PATH}/resources/cassandra/conf
ENV CASSANDRA_LOGS ${CASSANDRA_PATH}/logs
# Log directory for Management API startup logs to avoid issues:
# https://datastax.jira.com/browse/DB-4627
# https://issues.apache.org/jira/browse/CASSANDRA-16027
ENV MGMT_API_LOG_DIR /var/log/cassandra

COPY --from=builder /build/management-api-agent-dse-6.8/target/datastax-mgmtapi-agent-dse-6.8-0.1.0-SNAPSHOT.jar ${MAAC_PATH}/datastax-mgmtapi-agent-0.1.0-SNAPSHOT.jar
COPY --from=builder /build/management-api-server/target/datastax-mgmtapi-server-0.1.0-SNAPSHOT.jar ${MAAC_PATH}/
COPY --from=builder ${CDC_AGENT_PATH} ${CDC_AGENT_PATH}

USER root
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends wget iproute2; \
  rm -rf /var/lib/apt/lists/*

RUN chown -R dse:root ${CDC_AGENT_PATH} && \
    chmod -R g+w ${CDC_AGENT_PATH}

# backwards compat with upstream ENTRYPOINT
COPY scripts/dse-6.8-docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
  ln -sf /usr/local/bin/docker-entrypoint.sh /docker-entrypoint.sh && \
# fix for the missing mtab in the containerd
  ln -sf /proc/mounts /etc/mtab

EXPOSE 9103
EXPOSE 8080

USER dse

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mgmtapi"]
