from ghcr.io/romange/ubuntu-dev:20 as builder

ARG TARGETPLATFORM

WORKDIR /build
COPY tools/docker/fetch_release.sh /tmp/
COPY releases/dragonfly-* /tmp/

RUN curl -f -O https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c && \
     gcc -Wall -O2 su-exec.c -o su-exec

RUN /tmp/fetch_release.sh ${TARGETPLATFORM}


# Now prod image
FROM ubuntu:20.04

# ARG in fact change the env vars during the build process
# ENV persist the env vars for the built image as well.
ARG QEMU_CPU
ARG ORG_NAME=dragonflydb
ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title Dragonfly
LABEL org.opencontainers.image.source https://github.com/${ORG_NAME}/dragonfly


RUN groupadd -r -g 999 dfly && useradd -r -g dfly -u 999 dfly
RUN mkdir /data && chown dfly:dfly /data

VOLUME /data
WORKDIR /data
COPY tools/docker/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --from=builder /build/su-exec /usr/local/bin/
COPY --from=builder /build/dragonfly /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]

# For inter-container communication.
EXPOSE 6379

CMD ["dragonfly", "--logtostderr"]
