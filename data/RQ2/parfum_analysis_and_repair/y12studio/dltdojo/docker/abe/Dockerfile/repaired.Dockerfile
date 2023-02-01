FROM seegno/bitcoind:0.14.2-alpine
RUN apk --update --no-cache add python py-pip bash && \
    apk add --no-cache --virtual .builddeps git build-base musl-dev python-dev && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir pycrypto && pip install --no-cache-dir Crypto && \
    git clone --depth=1 https://github.com/bitcoin-abe/bitcoin-abe && \
    cd bitcoin-abe; python setup.py install && \
    apk --no-cache --purge del .builddeps && \
    rm -rf /tmp/*

WORKDIR /bitcoin-abe
ADD abe-sqlite.conf ./
ADD start.sh start105.sh /
RUN chmod +x /*.sh
ADD bitcoin.conf /home/bitcoin/.bitcoin/
CMD ["/start.sh"]