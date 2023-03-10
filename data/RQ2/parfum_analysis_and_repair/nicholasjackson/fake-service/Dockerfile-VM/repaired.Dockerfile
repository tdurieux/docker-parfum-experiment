# This image contains Fake Service Consul and Envoy, it can be used to simulate a Virtual Machine containing the Consul Agent
# and Envoy running as Daemon processes.
FROM nicholasjackson/consul-envoy:v1.12.2-v1.21.2 as base

# Setup bash and supervisord etc
RUN apt-get update && \
    apt-get install --no-install-recommends -y supervisor dnsmasq && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i 's/\/bin\/ash/\/bin\/bash/g' /etc/passwd

COPY entrypoint.sh /entrypoint.sh
COPY prestart.sh /prestart.sh

RUN chmod +x /entrypoint.sh
RUN chmod +x /prestart.sh

# Setup the supervisor d file
COPY fake-service.conf /etc/supervisor/conf.d/fake-service.conf

# Configure Dnsmasq to use Consul DN
RUN echo "server=/consul/127.0.0.1#8600" > /etc/dnsmasq.d/10-consul
RUN echo "server=127.0.0.11" >> /etc/dnsmasq.d/10-consul
COPY startdnsmasq.sh /startdnsmasq.sh
RUN chmod +x /startdnsmasq.sh

# Copy AMD binaries
FROM base AS image-amd64

COPY bin/linux/amd64/fake-service /app/fake-service
RUN chmod +x /app/fake-service

# Copy Arm 8 binaries
FROM base AS image-arm64

COPY bin/linux/arm64/fake-service /app/fake-service
RUN chmod +x /app/fake-service

FROM image-${TARGETARCH}

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
ARG BUILDPLATFORM
ARG BUILDARCH

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM $TARGETARCH $TARGETVARIANT"

# set default env vars so supervisor
# does not crash on start
ENV CONSUL_HTTP_ADDR=localhost:8500
ENV CONSUL_SERVER=localhost
ENV CONSUL_DATACENTER=dc1
ENV SERVICE_ID=null
ENV CONSUL_RETRY_INTERVAL=5s
ENV PRESTART_FILE=/prestart.sh

# add default config folder
RUN mkdir /config

# data directory for Consul
RUN mkdir -p /etc/consul

# Run supervisord in blocking mode
ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisor/supervisord.conf", "-n"]
