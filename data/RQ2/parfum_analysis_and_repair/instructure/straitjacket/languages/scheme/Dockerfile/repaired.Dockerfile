FROM buildpack-deps:jessie

RUN apt-get update && \
    apt-get install --no-install-recommends -y guile-2.0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd docker
USER docker

ENV GUILE_AUTO_COMPILE=0

ENTRYPOINT ["guile"]
