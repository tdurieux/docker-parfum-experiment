FROM temp

ARG DOCKER_VERSION=VERSION

RUN apt-get -y --no-install-recommends install \
        docker-ce=${DOCKER_VERSION} \
        docker-ce-cli=${DOCKER_VERSION} \
        docker-compose docker-compose-plugin && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/usr/bin/docker"]
