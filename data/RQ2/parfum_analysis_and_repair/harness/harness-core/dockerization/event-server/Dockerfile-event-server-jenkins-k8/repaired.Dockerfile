# to be used when building in Jenkins
FROM harness/serverjre_8:191
RUN yum install -y hostname tar gzip net-tools traceroute nmap procps && rm -rf /var/cache/yum

# Add the capsule JAR and config.yml
COPY event-server-capsule.jar event-service-config.yml key.pem cert.pem /opt/harness/

COPY scripts /opt/harness

RUN chmod +x /opt/harness/*.sh
RUN mkdir -p /opt/harness/plugins

RUN GRPC_HEALTH_PROBE_VERSION=v0.3.0 && \
    curl -f -Lso /bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

# install yq - a YAML query command line tool
RUN curl -f -Lso yq https://github.com/mikefarah/yq/releases/download/2.2.1/yq_linux_amd64
RUN chmod +x yq
RUN mv yq /usr/local/bin

WORKDIR /opt/harness

CMD [ "./run.sh" ]
