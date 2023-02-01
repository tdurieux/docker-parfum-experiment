FROM ubuntu:14.04
MAINTAINER izuolan <i@zuolan.me>

RUN apt-get -qq update && \
    apt-get install --no-install-recommends -q -y wget build-essential python-pip python-m2crypto && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir shadowsocks

#add chacha20
RUN wget https://download.libsodium.org/libsodium/releases/LATEST.tar.gz && \
    tar zxf LATEST.tar.gz && \
    cd libsodium* && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j2 && make install && \
    ldconfig && rm LATEST.tar.gz

ADD shadowsocks.json /etc/
ADD start.sh /usr/local/bin/start.sh
RUN chmod 755 /usr/local/bin/start.sh


CMD ["sh", "-c", "start.sh"]
#ENTRYPOINT ["/usr/local/bin/ssserver"]
