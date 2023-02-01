FROM m00re/bitcore:3.1.3-b2
# https://github.com/m00re/bitcore-docker
# https://github.com/seegno/docker-bitcoind/blob/master/0.14/Dockerfile

USER root
RUN useradd -r bitcoin

ENV GOSU_VERSION=1.9

RUN apt-get update -y \
  && apt-get install --no-install-recommends -y curl gnupg \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gpg --batch --keyserver hkp://p80.ha.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4

RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
	&& curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
	&& gpg --batch --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

ENV BITCOIN_VERSION=0.14.2
ENV BITCOIN_DATA=/home/bitcoin/.bitcoin \
  PATH=/opt/bitcoin-${BITCOIN_VERSION}/bin:$PATH

RUN curl -f -SL https://bitcoin.org/laanwj-releases.asc | gpg --batch --import \
  && curl -f -SLO https://bitcoin.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc \
  && curl -f -SLO https://bitcoin.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}${BITCOIN_BRANCH}-x86_64-linux-gnu.tar.gz \
  && gpg --batch --verify SHA256SUMS.asc \
  && grep " bitcoin-${BITCOIN_VERSION}${BITCOIN_BRANCH}-x86_64-linux-gnu.tar.gz\$" SHA256SUMS.asc | sha256sum -c - \
  && tar -xzf bitcoin-${BITCOIN_VERSION}${BITCOIN_BRANCH}-x86_64-linux-gnu.tar.gz -C /opt \
  && rm bitcoin-${BITCOIN_VERSION}${BITCOIN_BRANCH}-x86_64-linux-gnu.tar.gz SHA256SUMS.asc

RUN npm install insight-ui && npm cache clean --force;
ADD bitcoin.conf /home/node/bitcoind/
ADD start.sh /start.sh
RUN chmod +x /start.sh
# CMD ["/start.sh"]