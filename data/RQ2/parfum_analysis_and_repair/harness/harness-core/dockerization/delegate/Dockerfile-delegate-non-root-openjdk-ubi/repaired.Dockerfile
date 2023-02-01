FROM redhat/ubi8-minimal:8.4

LABEL name="harness/delegate:ubi-minimal" \
      vendor="Harness" \
      maintainer="Harness" \
      version="1.0"

RUN microdnf update \
 && microdnf install --nodocs \
    unzip \
    procps \
    hostname \
    lsof \
    findutils \
 && rm -rf /var/cache/yum \
 && microdnf clean all \
 && mkdir -p /opt/harness-delegate/

COPY scripts /opt/harness-delegate/

WORKDIR /opt/harness-delegate

ARG disable_client_tools
RUN ./client_tools.sh $disable_client_tools \
    && chmod -R 755 /opt/harness-delegate \
    && chgrp -R 0 /opt/harness-delegate  \
    && chmod -R g=u /opt/harness-delegate \
    && chown -R 1001 /opt/harness-delegate

ENV HOME=/opt/harness-delegate

USER 1001
COPY --chown=1001 --from=adoptopenjdk/openjdk11:x86_64-ubi-minimal-jre-11.0.14_9 /opt/java/openjdk/ ./jdk-11.0.14+9-jre/
COPY --chown=1001 --from=adoptopenjdk/openjdk8:jre8u242-b08-ubi-minimal /opt/java/openjdk/ ./jdk8u242-b08-jre/

ARG watcher_version
RUN curl -f -#k https://app.harness.io/public/shared/watchers/builds/openjdk-8u242/$watcher_version/watcher.jar -o watcher.jar
CMD ./entrypoint.sh && bash -c ' \
    while [[ ! -e watcher.log ]]; do sleep 1s; done; tail -F watcher.log & \
    while [[ ! -e delegate.log ]]; do sleep 1s; done; tail -F delegate.log'
