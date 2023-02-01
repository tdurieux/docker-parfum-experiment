FROM golang:buster

RUN set -xe && \
    apt-get update -y && \
    apt-get install -qy --no-install-recommends \
        cmake \
        git \
        make && rm -rf /var/lib/apt/lists/*;

CMD [ "make", "submodule", "test-core", "test-skipped" ]
