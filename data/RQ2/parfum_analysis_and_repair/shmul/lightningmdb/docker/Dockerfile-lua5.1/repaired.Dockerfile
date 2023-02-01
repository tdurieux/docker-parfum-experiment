FROM phusion/baseimage:0.9.19

ENV lua_ver 5.1
ENV luarocks_ver 2.3.0
ENV lmdb_ver 0.9.19


RUN apt-get update -y && apt-get install --no-install-recommends -y unzip curl make git && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y lua${lua_ver} liblua${lua_ver} liblua${lua_ver}-dev && rm -rf /var/lib/apt/lists/*;

# Install luarocks
RUN cd /tmp && \
    curl -f -L -O http://luarocks.org/releases/luarocks-${luarocks_ver}.tar.gz && \
    tar zxpf luarocks-${luarocks_ver}.tar.gz && \
    rm luarocks-${luarocks_ver}.tar.gz && \
    cd luarocks-${luarocks_ver} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && \
    make bootstrap && \
    cd /tmp && \
    rm -r /tmp/luarocks-${luarocks_ver}

RUN cd /tmp && \
    curl -f -L -O https://github.com/LMDB/lmdb/archive/LMDB_${lmdb_ver}.tar.gz && \
    tar -xzf LMDB_${lmdb_ver}.tar.gz && \
    rm LMDB_${lmdb_ver}.tar.gz && \
    cd lmdb-LMDB_${lmdb_ver}/libraries/liblmdb && \
    make all install && \
    ldconfig && \
    cd /tmp && \
    rm -r /tmp/lmdb-LMDB_${lmdb_ver}

ENV HOME /root
RUN mkdir -p $HOME/lightningmdb/temp
WORKDIR $HOME/lightningmdb

COPY *.lua *.c Makefile *.rockspec $HOME/lightningmdb/
RUN make BASE_DIR=/usr LUAINC=/usr/include/lua${lua_ver}
