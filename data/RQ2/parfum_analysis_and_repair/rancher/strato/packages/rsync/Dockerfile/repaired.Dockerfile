# TODO: remove dependency on attr
FROM strato-build

ENV VERSION 3.1.2
ENV LDFLAGS -s
RUN wget -P /usr/src/ https://rsync.samba.org/ftp/rsync/rsync-${VERSION}.tar.gz
RUN cd /usr/src/ && tar xf rsync*
RUN cd /usr/src/rsync* \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --prefix=/usr \
    --sysconfdir=/etc \
    --mandir=/usr/share/man \
    --localstatedir=/var \
    && make

RUN cd /usr/src/rsync* \
    && make install
