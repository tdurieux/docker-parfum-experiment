FROM alpine:3.12

# Install packages
RUN apk add --no-cache iptables ipset ca-certificates openvpn bash sudo openresolv

COPY bin/helpers/prepare-run-env.sh /usr/local/bin/prepare-run-env.sh
COPY bin/docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

COPY bin/package/config/common /etc/mysterium-node
COPY bin/package/config/linux /etc/mysterium-node

COPY ./build/e2e/myst /usr/bin/myst
