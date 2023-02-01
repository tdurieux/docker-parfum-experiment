FROM strato-build

ENV VERSION 3.2
ENV LDFLAGS -s
RUN wget -P /usr/src/ https://dev.gentoo.org/~blueness/eudev/eudev-${VERSION}.tar.gz
RUN cd /usr/src/ && tar xf eudev*
RUN cd /usr/src/eudev* \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --sysconfdir=/etc \
    --with-rootprefix= \
    --with-rootrundir=/run \
    --with-rootlibexecdir=/lib/udev \
    --libdir=/usr/lib \
    --enable-split-usr \
    --enable-manpages \
    --disable-hwdb \
    --enable-kmod \
    --exec-prefix=/ \
    && make

RUN cd /usr/src/eudev* \
    && make sharepkgconfigdir=/usr/lib/pkgconfig install
