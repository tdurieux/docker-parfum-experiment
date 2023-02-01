FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      curl \
      wget \
      git \
      ruby2.5-dev \
      build-essential \
      man-db \
      unzip \
    && gem install --no-ri --no-rdoc fpm-cookery \
    && apt-get clean \
    && rm -rf \
      /tmp/* \
      /root/.gem \
      /var/cache/debconf/* \
      /var/lib/gems/*/cache/* \
      /var/lib/apt/lists/* \
      /var/log/* \
      /usr/share/X11 \
      /usr/share/doc/*

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["fpm-cook"]