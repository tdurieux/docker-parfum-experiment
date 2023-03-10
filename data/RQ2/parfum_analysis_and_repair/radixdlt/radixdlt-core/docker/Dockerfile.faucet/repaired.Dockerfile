FROM alpine:3.9
LABEL maintainer="devops@radixdlt.com"
USER root

# add jdk
RUN apk add --no-cache openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

# add distTar
ADD faucet-service-*.tar /opt

# permissions
RUN mv /opt/faucet-service-* /opt/faucet-service && \
    mkdir /opt/faucet-service/etc && \
    chown -R nobody:nogroup /opt/faucet-service

COPY faucet-entrypoint.sh /

# workdir
WORKDIR /opt/faucet-service

# entrypoint
ENTRYPOINT ["/faucet-entrypoint.sh"]

CMD ["./bin/faucet-service"]

USER nobody:nogroup