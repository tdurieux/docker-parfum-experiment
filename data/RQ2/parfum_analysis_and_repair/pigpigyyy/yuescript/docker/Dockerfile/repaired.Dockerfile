FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y lua5.1 liblua5.1-0-dev cmake git unzip wget && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y fuse libfuse-dev && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp && wget https://luarocks.org/releases/luarocks-3.3.1.tar.gz \
    && tar zxpf luarocks-3.3.1.tar.gz \
    && cd luarocks-3.3.1 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make && make install \
    && cd /tmp; rm -rf luarocks-3.3.1 luarocks-3.3.1.tar.gz

RUN luarocks install yuescript

CMD ["yue"]
