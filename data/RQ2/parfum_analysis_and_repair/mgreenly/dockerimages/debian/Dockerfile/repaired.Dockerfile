ARG SRC_HOST="docker.io"
ARG SRC_REGISTRY="library"
ARG SRC_IMAGE="debian"
ARG SRC_TAG="11.0-slim"
ARG SRC=${SRC_HOST}/${SRC_REGISTRY}/${SRC_IMAGE}:${SRC_TAG}

FROM ${SRC}

# COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN DEBIAN_FRONTEND=noninteractive \
    && cd /tmp \
    && apt-get -q -y update \
    && apt-get -q --no-install-recommends -y install \
       libffi7 && rm -rf /var/lib/apt/lists/*;

# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# CMD ["/bin/bash"]
