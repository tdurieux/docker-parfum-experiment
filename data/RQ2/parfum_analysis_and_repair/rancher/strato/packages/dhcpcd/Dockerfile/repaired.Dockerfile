FROM strato-build

ENV VERSION 6.11.5
ENV LDFLAGS -s
RUN wget -P /usr/src/ https://roy.marples.name/downloads/dhcpcd/dhcpcd-${VERSION}.tar.xz
RUN cd /usr/src/ && tar xf dhcpcd*
RUN cd /usr/src/dhcpcd* \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --sysconfdir=/etc \
    --mandir=/usr/share/man \
    --localstatedir=/var \
    --libexecdir=/usr/lib/dhcpcd \
    --dbdir=/var/lib/dhcpcd \
    && make

RUN cd /usr/src/dhcpcd* \
    && make install
