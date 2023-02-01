FROM python:3.7-slim-stretch

MAINTAINER x0rxkov <x0rxkov@protonmail.com>

ARG TWINT_VERSION=v2.1.19

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN \
 apt-get update && \
 apt-get install --no-install-recommends -y \
git && rm -rf /var/lib/apt/lists/*;

RUN \
 pip3 install --no-cache-dir --upgrade -e git+https://github.com/twintproject/twint.git@v2.1.19#egg=twint

RUN \
apt-get clean autoclean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]
VOLUME /twint
WORKDIR /opt/twint/data
