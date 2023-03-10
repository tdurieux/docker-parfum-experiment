FROM ubuntu:xenial

ENV BTCDARK_VERSION=0.12.1
RUN apt-get update ; apt-get install --no-install-recommends -y curl jq && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp; curl -f --insecure -sL https://github.com/btcdrak/bitcoin/releases/download/v${BTCDARK_VERSION}-addrindex/bitcoin-${BTCDARK_VERSION}-addrindex-linux64.tar.gz | tar zx \
    && mv bitcoin-${BTCDARK_VERSION}/bin/bitcoin* /usr/local/bin/
# install xcp
ENV XCPLIB_VERSION=9.55.1
# ENV XCPCLI_VERSION=1.1.2
RUN apt-get install --no-install-recommends -y git python3-pip; rm -rf /var/lib/apt/lists/*; pip3 install --no-cache-dir --upgrade pip && \
    mkdir /xcp; cd /xcp ; curl -f --insecure -vL https://github.com/CounterpartyXCP/counterparty-lib/archive/${XCPLIB_VERSION}.tar.gz | tar zx && \
    cd /xcp/counterparty-lib-${XCPLIB_VERSION}; pip3 install --no-cache-dir -r requirements.txt; python3 setup.py install
# https://github.com/CounterpartyXCP/counterparty-cli/issues/104
RUN cd /xcp; git clone --depth=1 https://github.com/CounterpartyXCP/counterparty-cli.git &&\
    cd /xcp/counterparty-cli ; pip3 install --no-cache-dir -r requirements.txt; python3 setup.py install &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD start.sh /
RUN chmod a+x /start.sh
ADD bitcoin.conf /root/.bitcoin/
ADD server.conf client.conf /root/.config/counterparty/
