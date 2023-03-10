FROM alpine:3.12.3
RUN apk upgrade --no-cache && \
  apk add --no-cache wget ca-certificates && update-ca-certificates
RUN mkdir -p /opt/cni/bin && wget -O- https://github.com/containernetworking/plugins/releases/download/v0.9.1/cni-plugins-linux-amd64-v0.9.1.tgz | tar xz -C /opt/cni/bin
COPY launch-cnideploy.sh /usr/local/bin/
CMD ["/usr/local/bin/launch-cnideploy.sh"]