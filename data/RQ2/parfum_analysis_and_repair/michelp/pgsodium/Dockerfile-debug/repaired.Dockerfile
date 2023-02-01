ARG version
FROM postgres:${version}
ARG version

# RUN apt-get update && apt-get install -y make git postgresql-server-dev-${version} curl build-essential gdb
RUN apt-get update && apt-get install --no-install-recommends -y make git curl build-essential gdb libreadline-dev bison flex zlib1g-dev tmux zile zip gawk && rm -rf /var/lib/apt/lists/*;

RUN git clone --branch REL_${version}_STABLE https://github.com/postgres/postgres.git --depth=1 && \
    cd postgres && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --prefix=/usr/ \
    --enable-debug \
    --enable-depend --enable-cassert --enable-profiling \
    CFLAGS="-ggdb -Og -g3 -fno-omit-frame-pointer" \
#    CFLAGS="-O3" \
    && make -j 4 && make install

RUN curl -f -s -L https://github.com/theory/pgtap/archive/v1.1.0.tar.gz | tar zxvf - && cd pgtap-1.1.0 && make && make install
RUN curl -f -s -L https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz | tar zxvf - && cd libsodium-1.0.18 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make check && make install
RUN mkdir "/pgsodium"
WORKDIR "/pgsodium"
COPY . .
RUN make && make install
RUN ldconfig
RUN curl -f -O https://raw.githubusercontent.com/tvondra/gdbpg/master/gdbpg.py
RUN cd `pg_config --sharedir`/extension/
RUN cp getkey_scripts/pgsodium_getkey_urandom.sh `pg_config --sharedir`/extension/pgsodium_getkey
RUN sed -i 's/exit//g' `pg_config --sharedir`/extension/pgsodium_getkey
RUN chmod +x `pg_config --sharedir`/extension/pgsodium_getkey
