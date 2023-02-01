FROM debian:8
WORKDIR /app
ENV TMP_NAME=/tmp/dns-proxy-server.tgz
RUN apt-get update && apt-get install --force-yes -y curl
RUN curl -L https://github.com/mageddo/dns-proxy-server/releases/download/2.14.6/dns-proxy-server-linux-amd64-2.14.6.tgz > $TMP_NAME && \
	tar -xvf $TMP_NAME -C /app/ && rm -f $TMP_NAME && apt-get purge --force-yes -y curl

VOLUME ["/var/run/docker.sock", "/var/run/docker.sock"]
CMD ["bash", "-c", "/app/dns-proxy-server"]
