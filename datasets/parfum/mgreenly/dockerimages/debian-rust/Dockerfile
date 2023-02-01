ARG SRC_HOST="docker.io"
ARG SRC_REGISTRY="library"
ARG SRC_IMAGE="rust"
ARG SRC_TAG="1.55.0-slim-bullseye"
ARG SRC=${SRC_HOST}/${SRC_REGISTRY}/${SRC_IMAGE}:${SRC_TAG}

FROM ${SRC}

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN DEBIAN_FRONTEND=noninteractive \
    && cd /tmp \
    && apt-get -q -y update \
    && apt-get -q -y install \
       libffi7

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
