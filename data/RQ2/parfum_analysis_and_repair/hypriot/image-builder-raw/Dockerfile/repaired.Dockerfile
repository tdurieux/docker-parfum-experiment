FROM debian:stretch

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    dosfstools \
    kpartx \
    ruby \
    zip \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && \
    gem install --no-document serverspec && rm -rf /root/.gem;

COPY builder /builder/
