FROM partlab/ubuntu-php

MAINTAINER Régis Gaidot <regis@partlab.co>

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV LANG en_US.UTF-8

RUN apt-get update && \
    apt-get install --no-install-recommends -y hhvm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/hhvm"]
