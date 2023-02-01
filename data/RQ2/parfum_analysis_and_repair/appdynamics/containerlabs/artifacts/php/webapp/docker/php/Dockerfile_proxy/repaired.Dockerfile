FROM openjdk:8-jre-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y procps binutils vim curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY ./php-agent/proxy /opt/appdynamics/php-agent/proxy

COPY ./start-proxy.sh /opt/appdynamics/start-proxy.sh

RUN chmod +x /opt/appdynamics/start-proxy.sh


ENTRYPOINT ["/bin/bash", "/opt/appdynamics/start-proxy.sh"]
