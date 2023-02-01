ARG DOCKER_IMAGE_PARENT
FROM $DOCKER_IMAGE_PARENT

VOLUME /builds/worker/checkouts
VOLUME /builds/worker/.cache

RUN apt-get update && \
    apt-get -y --no-install-recommends install osslsigncode && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
