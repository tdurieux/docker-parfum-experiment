FROM ubuntu:19.10

MAINTAINER Sébastien Houzet (yoozio.com) <sebastien@yoozio.com>

ARG TWINT_VERSION=v2.1.14

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN \
 apt-get update && \
 apt-get install --no-install-recommends -y \
git \
python3-pip && rm -rf /var/lib/apt/lists/*;

RUN \
 pip3 install --no-cache-dir --upgrade -e git+https://github.com/twintproject/twint.git@v2.1.14#egg=twint

RUN \
apt-get clean autoclean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]
VOLUME /twint
WORKDIR /opt/twint/data
