ARG FROM_IMAGE=zyclonite/zerotier
ARG FROM_VERSION=latest

FROM ${FROM_IMAGE}:${FROM_VERSION}

LABEL org.opencontainers.image.title="zerotier" \
      org.opencontainers.image.version="bridge-${ZT_VERSION}" \
      org.opencontainers.image.description="ZeroTier One as Docker Image" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/zyclonite/zerotier-docker"

ENV LOG_PATH=/var/log/supervisor

COPY scripts/entrypoint-bridge.sh /usr/sbin/

RUN apk add --no-cache --purge --clean-protected iptables \
  && rm -rf /var/cache/apk/*

EXPOSE 9993/udp

ENTRYPOINT ["entrypoint-bridge.sh"]

CMD ["-U"]