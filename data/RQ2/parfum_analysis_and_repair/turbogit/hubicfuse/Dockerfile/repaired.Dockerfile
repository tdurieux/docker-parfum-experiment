FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y gcc make curl libfuse-dev pkg-config \
    libcurl4-openssl-dev libxml2-dev libssl-dev libjson-c-dev libmagic-dev && \
    rm -rf /var/lib/apt/lists/*

COPY . /hubicfuse
WORKDIR /hubicfuse

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make


ENTRYPOINT ["/hubicfuse/docker-entrypoint.sh"]
