FROM registry.access.redhat.com/ubi8/ubi-minimal:8.6

ARG TARGETARCH

ARG RELEASE

LABEL maintainer="MinIO Inc <dev@min.io>"

COPY CREDITS /licenses/CREDITS
COPY LICENSE /licenses/LICENSE

RUN \
    microdnf update --nodocs && \
    microdnf install curl ca-certificates shadow-utils --nodocs && \
    microdnf clean all && \
    curl -f -s -q https://dl.minio.io/client/mc/release/linux-${TARGETARCH}/archive/mc.${RELEASE} -o /usr/bin/mc && \
    chmod +x /usr/bin/mc

ENTRYPOINT ["mc"]
