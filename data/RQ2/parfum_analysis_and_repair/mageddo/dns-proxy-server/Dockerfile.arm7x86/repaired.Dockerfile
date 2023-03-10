FROM arm32v7/debian:10-slim
ADD build/dns-proxy-server-linux-arm-*.tgz /app/
WORKDIR /app
LABEL dps.container=true
VOLUME ["/var/run/docker.sock", "/var/run/docker.sock"]
ENTRYPOINT ["/app/dns-proxy-server"]