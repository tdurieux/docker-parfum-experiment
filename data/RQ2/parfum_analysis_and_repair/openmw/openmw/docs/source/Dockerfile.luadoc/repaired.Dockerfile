FROM ubuntu:22.04

RUN apt update && \
    apt install --no-install-recommends -y make gcc libreadline-dev wget unzip git zip && \
    rm -rf /var/lib/apt/lists/*

ADD https://www.lua.org/ftp/lua-5.1.5.tar.gz /tmp/lua-5.1.5.tar.gz
RUN tar -zxf /tmp/lua-5.1.5.tar.gz -C /tmp && rm /tmp/lua-5.1.5.tar.gz
RUN cd /tmp/lua-5.1.5 && \
    make linux -j $(nproc) && \
    make install && \
    rm -r /tmp/lua-5.1.5

ADD https://luarocks.org/releases/luarocks-2.4.2.tar.gz /tmp/luarocks-2.4.2.tar.gz
RUN tar -zxpf /tmp/luarocks-2.4.2.tar.gz -C /tmp && rm /tmp/luarocks-2.4.2.tar.gz
RUN cd /tmp/luarocks-2.4.2 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make build -j $(nproc) && \
    make install && \
    rm -r /tmp/luarocks-2.4.2

ADD https://gitlab.com/ptmikheev/openmw-luadocumentor/-/raw/master/luarocks/openmwluadocumentor-0.1.1-1.rockspec /tmp/openmwluadocumentor-0.1.1-1.rockspec
RUN cd /tmp && \
    luarocks pack openmwluadocumentor-0.1.1-1.rockspec && \
    luarocks install openmwluadocumentor-0.1.1-1.src.rock && \
    rm /tmp/openmwluadocumentor-0.1.1-1.rockspec /tmp/openmwluadocumentor-0.1.1-1.src.rock
