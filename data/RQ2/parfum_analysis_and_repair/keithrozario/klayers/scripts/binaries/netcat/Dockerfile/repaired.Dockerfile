FROM layerbuilder:latest

LABEL maintainer="keith@keithrozario.com"

WORKDIR /tmp

RUN wget https://sourceforge.net/projects/netcat/files/netcat/0.7.1/netcat-0.7.1.tar.gz && \
    tar -xzvf netcat-0.7.1.tar.gz && \
    cd netcat-0.7.1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && make install && \
    mkdir /tmp/layer && mkdir /tmp/layer/bin && mkdir /tmp/layer/lib && \
    cp /usr/local/bin/netcat /tmp/layer/bin/ && \
    cp /lib64/libc.so.6 /tmp/layer/lib/ && \
    cp /lib64/ld-linux-x86-64.so.2 /tmp/layer/lib && \
    cd /tmp/layer && \
    zip netcat.zip . -r && rm netcat-0.7.1.tar.gz