FROM debian:7.8

ENV \
    RUN_DEPS="python" \
    BUILD_DEPS="python-pip" \
    DEBIAN_FRONTEND="noninteractive"

ADD . /opt/illacceptanything

RUN \

    apt-get update \
    && apt-get -y --no-install-recommends install $BUILD_DEPS $RUN_DEPS \

    # Do stuff... but what?

COPY . /opt/illacceptanything && rm -rf /var/lib/apt/lists/*;

USER root
WORKDIR /opt/illacceptanything
ENTRYPOINT ["/bin/bash"]
