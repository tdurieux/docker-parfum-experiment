FROM debian:bullseye-slim as fetch-ziti-artifacts

# This build stage grabs artifacts that are copied into the final image.
# It uses the same base as the final image to maximize docker cache hits.

ARG ARTIFACTS_DIR=./build/programs/ziti-edge-tunnel
# e.g. linux
#ARG TARGETARCH
# e.g. v7 (OS variant)
#ARG TARGETOS
# e.g. arm
# TARGETVARIANT

WORKDIR /tmp

RUN apt-get -q update && apt-get -q install -y --no-install-recommends curl ca-certificates && rm -rf /var/lib/apt/lists/*;
# workaround for `openssl rehash` not working on arm.
RUN /bin/bash -c "if ! compgen -G '/etc/ssl/certs/*.[0-9]' > /dev/null; then c_rehash /etc/ssl/certs; fi"

#COPY ${ARTIFACTS_DIR}/${TARGETARCH}/${TARGETOS}/ziti-edge-tunnel .
COPY ${ARTIFACTS_DIR}/ziti-edge-tunnel .

################
#
#  Main Image
#
################

FROM debian:bullseye-slim

ARG DOCKER_BUILD_DIR=./docker
ARG ZITI_TUNNELER_BIN=ziti-edge-tunnel

RUN mkdir -p /usr/local/bin /etc/ssl/certs
RUN apt-get -q update && apt-get -q install -y --no-install-recommends iproute2 libsystemd0 openssl && rm -rf /var/lib/apt/lists/*;
COPY --from=fetch-ziti-artifacts /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs
COPY --from=fetch-ziti-artifacts /tmp/${ZITI_TUNNELER_BIN} /usr/local/bin
COPY ${DOCKER_BUILD_DIR}/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
RUN mkdir -p /ziti-edge-tunnel

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "run" ]
