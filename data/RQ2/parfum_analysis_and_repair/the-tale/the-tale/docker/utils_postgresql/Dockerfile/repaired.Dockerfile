ARG TT_BASE_IMAGE_VERSION
ARG TT_CONTAINERS_REGISTRY

FROM $TT_CONTAINERS_REGISTRY/the-tale/core-postgresql:$TT_BASE_IMAGE_VERSION

ENTRYPOINT ["entrypoint.sh"]

RUN apt-get update && apt-get install --no-install-recommends -y awscli wait-for-it && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /backups

COPY ./bin/* /usr/bin/
