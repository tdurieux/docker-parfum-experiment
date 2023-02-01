FROM ubuntu:xenial

ENV VERSION=1.0-alpha-27
RUN apt-get update ; apt-get install --no-install-recommends -y curl jq \
    && cd /tmp; rm -rf /var/lib/apt/lists/*; curl -f --insecure -sL https://www.multichain.com/download/multichain-$VERSION.tar.gz | tar zx; mv multichain-$VERSION multichain \
    && cd multichain ; mv multichaind multichain-cli multichain-util /usr/local/bin
ADD start.sh /
RUN chmod +x /start.sh
RUN multichain-util create chain1 ; multichain-util create chain2
RUN echo 'rpcuser=user\nrpcpassword=pass' >> /root/.multichain/multichain.conf
