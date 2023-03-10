FROM strato-build

ENV VERSION 2.2.52
ENV LDFLAGS -s
RUN wget -P /usr/src/ https://download.savannah.gnu.org/releases/acl/acl-${VERSION}.src.tar.gz
RUN cd /usr/src/ && tar xf acl*
RUN cd /usr/src/acl* \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --prefix=/usr \
    --libdir=/lib \
    --libexecdir=/usr/lib \
    --disable-gettext \
    && make

RUN cd /usr/src/acl* \
    && make install install-lib install-dev
