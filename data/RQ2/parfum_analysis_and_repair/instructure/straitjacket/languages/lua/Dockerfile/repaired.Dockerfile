FROM buildpack-deps:jessie

RUN apt-get update && \
    apt-get install --no-install-recommends -y lua5.2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd docker
USER docker

ENTRYPOINT ["lua"]
