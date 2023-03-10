ARG DOCKER_TAG

FROM thorax/erigon:${DOCKER_TAG}

# Unused, this is here to avoid build time complaints
ARG BUILD_TARGET

ARG UID=10001

USER root

RUN apk --no-cache add shadow bash && groupmod -g "${UID}" erigon && usermod -u "${UID}" -g "${UID}" erigon

RUN mkdir -p /var/lib/erigon && chown -R erigon:erigon /var/lib/erigon

COPY ./docker-entrypoint.sh /usr/local/bin/

USER erigon

ENTRYPOINT ["erigon"]