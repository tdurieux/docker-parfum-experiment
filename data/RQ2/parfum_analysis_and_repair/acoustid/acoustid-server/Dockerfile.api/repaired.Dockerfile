ARG IMAGE=quay.io/acoustid/acoustid-server
ARG VERSION=master
FROM ${IMAGE}:${VERSION}

EXPOSE 3031

HEALTHCHECK CMD [ curl -qf https://localhost:3031/_health_docker || exit 1]


CMD ["/opt/acoustid/server/admin/docker/run-api.sh"]
