# to be used when building in Jenkins
FROM us.gcr.io/platform-205701/alpine:safe-alpine3.15.4-bt1276-apm

# Add the capsule JAR and config.yml
COPY event-server-capsule.jar event-service-config.yml key.pem cert.pem protocol.info /opt/harness/

COPY scripts /opt/harness

RUN wget https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_amd64 -O /usr/bin/yq -O /usr/bin/yq
RUN chmod +x /usr/bin/yq

RUN chmod +x /opt/harness/*.sh
RUN mkdir /opt/harness/plugins

RUN GRPC_HEALTH_PROBE_VERSION=v0.3.0 && \
    curl -f -Lso /bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

WORKDIR /opt/harness

CMD [ "./run.sh" ]
