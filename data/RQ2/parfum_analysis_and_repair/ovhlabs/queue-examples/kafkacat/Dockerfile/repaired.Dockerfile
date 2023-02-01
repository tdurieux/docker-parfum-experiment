FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential python curl git openssl \
    zlib1g-dev libssl-dev libsasl2-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/edenhill/librdkafka
RUN cd librdkafka && \
    git checkout tags/v0.9.2 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    echo '' >> config.h && \
    echo '#define WITH_SSL 1' >> config.h && \
    echo '#define WITH_SASL 1' >> config.h && \
    make && \
    make install

RUN git clone https://github.com/edenhill/kafkacat
RUN cd kafkacat && \
    git checkout tags/1.3.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install

ENV LD_LIBRARY_PATH /usr/local/lib
ENTRYPOINT ["kafkacat"]