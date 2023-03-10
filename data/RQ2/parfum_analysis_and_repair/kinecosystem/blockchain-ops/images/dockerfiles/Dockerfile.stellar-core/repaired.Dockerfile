FROM ubuntu:18.04

# (optional) install aws cli
# required for publishing history to s3
RUN RUN_DEPS="curl libpq5 python3-pip"; \
    apt-get -qq update && apt-get -qq -y --no-install-recommends install $RUN_DEPS \
    && pip3 -qq --no-cache-dir install awscli \
    && apt-get -qq autoremove $BUILD_DEPS \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
    /opt/stellar-core \
    /tmp/stellar-core

VOLUME ["/opt/stellar-core", "/tmp/stellar-core"]
WORKDIR /opt/stellar-core
EXPOSE 11625 11626
ENTRYPOINT ["/usr/local/bin/stellar-core"]

COPY ./volumes/core-git/src/stellar-core /usr/local/bin/
