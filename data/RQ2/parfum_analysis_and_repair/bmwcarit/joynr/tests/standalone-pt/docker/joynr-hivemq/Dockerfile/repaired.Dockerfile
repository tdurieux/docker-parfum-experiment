FROM openjdk:11-jre-slim

LABEL com.jfrog.artifactory.retention.maxCount="25"

ARG HIVEMQ_VERSION=4.3.2
ENV HIVEMQ_GID=10000
ENV HIVEMQ_UID=10000

# Additional JVM options, may be overwritten by user
ENV JAVA_OPTS "-XX:+UnlockExperimentalVMOptions -XX:+UseNUMA"

# Default allow all extension, set this to false to disable it
ENV HIVEMQ_ALLOW_ALL_CLIENTS "true"

# gosu for root step-down to user-privileged process
ENV GOSU_VERSION 1.11

# Set locale
ENV LANG=en_US.UTF-8

# gosu setup
RUN set -x \
        && apt-get update && apt-get install -y --no-install-recommends curl gnupg-agent gnupg dirmngr unzip \
        && curl -fSL "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" -o /usr/local/bin/gosu \
        && curl -fSL "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" -o /usr/local/bin/gosu.asc \
        && export GNUPGHOME="$(mktemp -d)" \
        && curl -fsSL "https://keys.openpgp.org/vks/v1/by-fingerprint/B42F6819007F00F88E364FD4036A9C25BF357DD4" | gpg --batch --import \
        && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
        && rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
        && { command -v gpgconf && gpgconf --kill all || :; } \
        && chmod +x /usr/local/bin/gosu \
        && gosu nobody true \
        && apt-get purge -y gpg dirmngr && rm -rf /var/lib/apt/lists/*

COPY config.xml /opt/config.xml
COPY docker-entrypoint.sh /opt/docker-entrypoint.sh

# HiveMQ setup
RUN curl -f -L https://www.hivemq.com/releases/hivemq-${HIVEMQ_VERSION}.zip -o /opt/hivemq-${HIVEMQ_VERSION}.zip \
    && unzip /opt/hivemq-${HIVEMQ_VERSION}.zip  -d /opt/ \
    && rm -f /opt/hivemq-${HIVEMQ_VERSION}.zip \
    && ln -s /opt/hivemq-${HIVEMQ_VERSION} /opt/hivemq \
    && mv /opt/config.xml /opt/hivemq-${HIVEMQ_VERSION}/conf/config.xml \
    && groupadd --gid ${HIVEMQ_GID} hivemq \
    && useradd -g hivemq -d /opt/hivemq -s /bin/bash --uid ${HIVEMQ_UID} hivemq \
    && chmod -R 775 /opt \
    && chmod +x /opt/hivemq/bin/run.sh /opt/docker-entrypoint.sh

# Substitute eval for exec and replace OOM flag if necessary (for older releases). This is necessary for proper signal propagation
RUN sed -i -e 's|eval \\"java\\" "$HOME_OPT" "$JAVA_OPTS" -jar "$JAR_PATH"|exec "java" $HOME_OPT $JAVA_OPTS -jar "$JAR_PATH"|' /opt/hivemq/bin/run.sh && \
    sed -i -e "s|-XX:OnOutOfMemoryError='sleep 5; kill -9 %p'|-XX:+CrashOnOutOfMemoryError|" /opt/hivemq/bin/run.sh

# Make broker data persistent throughout stop/start cycles
VOLUME /opt/hivemq/data

# Persist log data
VOLUME /opt/hivemq/log

#mqtt-clients
EXPOSE 1883

#websockets
EXPOSE 8000

#HiveMQ Control Center
EXPOSE 8080

WORKDIR /opt/hivemq

ENTRYPOINT ["/opt/docker-entrypoint.sh"]
CMD ["/opt/hivemq/bin/run.sh"]
