ARG BUILD_TAG=?
ARG REGISTRY_PATH=?
ARG ONPREM_PATH=?
ARG SERVICE_NAME=?
FROM ${REGISTRY_PATH}/${ONPREM_PATH}/${SERVICE_NAME}:${BUILD_TAG}

ARG APPD_AGENT=?
ARG TAKIPI_AGENT=?
ARG OCELET_AGENT=?
ARG ET_AGENT=?

USER root

COPY --chown=65534:65534 --chmod=711 ./${APPD_AGENT} /opt/harness/
ADD --chown=65534:65534 --chmod=711 ./${TAKIPI_AGENT} /opt/harness/
ADD --chown=65534:65534 --chmod=711 ./${OCELET_AGENT} /opt/harness/
ADD --chown=65534:65534 --chmod=711 ./${ET_AGENT} /opt/harness/

USER 65534