ARG ALPINE_ARCH=amd64
FROM ${ALPINE_ARCH}/alpine:3.15.4
LABEL maintainers="Kubernetes Authors"
LABEL description="Barbican KMS Plugin"

ARG ARCH=amd64
ADD barbican-kms-plugin-${ARCH} /bin/barbican-kms-plugin