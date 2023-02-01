FROM ubuntu:14.04
ENV lua_ver 5.2
ENV luarocks_ver 2.3.0
ENV lmdb_ver 0.9.17
ENV lightningmdb_ver 0.9.17.4-1

RUN apt-get update -y && apt-get install --no-install-recommends -y unzip curl make git && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y lua${lua_ver} liblua${lua_ver} liblua${lua_ver}-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsqlite3-dev sqlite3 && rm -rf /var/lib/apt/lists/*;

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


RUN luarocks install copas
RUN luarocks install lightningmdb ${lightningmdb_ver}
RUN luarocks install luaposix
RUN luarocks install lunitx
RUN luarocks install lsqlite3
RUN luarocks install xxhash

ENV HOME /root
WORKDIR $HOME

COPY *.lua $HOME/
COPY tests $HOME/tests
COPY fdi $HOME/fdi/
RUN mkdir -p $HOME/tests/temp

CMD lunit.sh tests/test_*.lua
