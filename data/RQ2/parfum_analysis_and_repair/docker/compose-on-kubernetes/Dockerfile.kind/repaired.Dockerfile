ARG KUBERNETES_VERSION
ARG BASE_IMAGE=kindest/node:v${KUBERNETES_VERSION}
FROM ${BASE_IMAGE}
COPY pre-loaded-images/*.tar kind/images/