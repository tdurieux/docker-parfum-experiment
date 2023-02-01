FROM projectunik/compilers-rump-base-xen:b679f2ea93988c9b

RUN apt-get update && apt-get install --no-install-recommends -y --force-yes texinfo && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://ftp.gnu.org/gnu/gdb/gdb-7.11.tar.gz | tar xz -C /opt/
RUN cd /opt/gdb-7.11/gdb && curl -f 'https://sourceware.org/bugzilla/attachment.cgi?id=8512&action=diff&collapsed=&headers=1&format=raw' | patch

RUN cd /opt/gdb-7.11 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --target=x86_64-linux-gnu && \
    make && \
    make install