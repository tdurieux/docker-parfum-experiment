ARG CONTAINER_GRAFANA_TAG=8.3.6
ARG TAG=latest
ARG PROJ_NAME=ntap-grafana
FROM grafana/grafana:${CONTAINER_GRAFANA_TAG}