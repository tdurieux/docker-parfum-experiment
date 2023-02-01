FROM typesense/typesense-development:29-DEC-2021-1

RUN apt-get install --no-install-recommends -y texinfo libc6-dbg && rm -rf /var/lib/apt/lists/*;

ADD http://ftp.gnu.org/gnu/gdb/gdb-7.11.tar.gz /opt/gdb-7.11.tar.gz
RUN tar -C /opt -xf /opt/gdb-7.11.tar.gz && rm /opt/gdb-7.11.tar.gz
RUN cd /opt/gdb-7.11 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j8 && make install

ADD https://sourceware.org/pub/valgrind/valgrind-3.17.0.tar.bz2 /opt/valgrind-3.17.0.tar.bz2
RUN tar -C /opt -xf /opt/valgrind-3.17.0.tar.bz2 && rm /opt/valgrind-3.17.0.tar.bz2
RUN cd /opt/valgrind-3.17.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make -j8 && make install
