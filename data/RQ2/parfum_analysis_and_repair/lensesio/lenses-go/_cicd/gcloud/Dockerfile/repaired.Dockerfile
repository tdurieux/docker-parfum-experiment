ARG GCLOUD_DOCKER_IMAGE
FROM ${GCLOUD_DOCKER_IMAGE}

RUN apt-get update && apt-get install --no-install-recommends -y \
    zip && rm -rf /var/lib/apt/lists/*;
