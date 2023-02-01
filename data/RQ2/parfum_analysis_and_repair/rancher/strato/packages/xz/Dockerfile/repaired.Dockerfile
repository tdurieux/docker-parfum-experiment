FROM strato-build

ENV VERSION 5.2.2
ENV LDFLAGS -s
RUN wget -P /usr/src/ https://tukaani.org/xz/xz-${VERSION}.tar.gz
RUN cd /usr/src/ && tar xf xz*
RUN cd /usr/src/xz* \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --prefix=/usr \
    --sysconfdir=/etc \
    --mandir=/usr/share/man \
    --infodir=/usr/share/info \
    --localstatedir=/var \
    --disable-rpath \
    --disable-werror \
    && make

RUN cd /usr/src/xz* \
    && make install
