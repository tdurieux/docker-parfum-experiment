FROM ubuntu:xenial
RUN apt-get update && apt-get install --no-install-recommends -y curl jq && rm -rf /var/lib/apt/lists/*;
ENV DVER=1.0.1.1
ENV SVER=1.0.1
RUN cd /tmp && curl -f --insecure -sL https://www.bitcoinunlimited.info/downloads/bitcoinUnlimited-${DVER}-linux64.tar.gz | tar zx \
    && mv /tmp/bitcoinUnlimited-${SVER}/bin/* /usr/bin/
ADD bitcoin.conf /root/.bitcoin/
ADD start.sh /
RUN chmod +x /start.sh
EXPOSE 18332 18333
