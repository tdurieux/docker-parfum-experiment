FROM buildpack-deps:jessie

RUN apt-get update && \
    apt-get install --no-install-recommends -y php5-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd docker
USER docker

ENTRYPOINT ["php5"]
