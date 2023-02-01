FROM redhat/ubi8-minimal:8.4

LABEL name="harness/delegate-immutable" \
      vendor="Harness" \
      maintainer="Harness"

RUN microdnf update \
  && microdnf install --nodocs \
    procps \
    hostname \
    lsof \
    findutils \
  && rm -rf /var/cache/yum \
  && microdnf clean all \
  && mkdir -p /opt/harness-delegate/

COPY immutable-scripts /opt/harness-delegate/
COPY scripts/client_tools.sh /opt/harness-delegate/client_tools.sh

WORKDIR /opt/harness-delegate

ARG disable_client_tools=true
RUN ./client_tools.sh $disable_client_tools \
    && chmod -R 755 /opt/harness-delegate \
    && chgrp -R 0 /opt/harness-delegate  \
    && chmod -R g=u /opt/harness-delegate \
    && chown -R 1001 /opt/harness-delegate

RUN rm /opt/harness-delegate/client_tools.sh

COPY --from=adoptopenjdk/openjdk11:x86_64-ubi-minimal-jre-11.0.14_9 /opt/java/openjdk/ /opt/java/openjdk/

ENV HOME=/opt/harness-delegate
ENV JAVA_HOME=/opt/java/openjdk/
ENV PATH="$JAVA_HOME/bin:${PATH}"

COPY ./delegate.jar ./delegate.jar

USER 1001

CMD [ "./start.sh" ]