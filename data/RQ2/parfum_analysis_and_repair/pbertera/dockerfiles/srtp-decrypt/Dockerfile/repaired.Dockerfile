FROM debian:jessie
MAINTAINER Pietro Bertera <pietro@bertera.it>

RUN apt-get update \
    && apt-get install --no-install-recommends -y git libpcap-dev libgcrypt-dev build-essential && rm -rf /var/lib/apt/lists/*;

RUN mkdir /opt/srtp-decrypt && cd /opt/srtp-decrypt && \
    git clone https://github.com/gteissier/srtp-decrypt.git . && make

ENTRYPOINT ["/opt/srtp-decrypt/srtp-decrypt"]
