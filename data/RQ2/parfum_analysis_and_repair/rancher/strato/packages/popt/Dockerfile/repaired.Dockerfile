FROM strato-build

ENV VERSION 1.16
ENV LDFLAGS -s
RUN wget -P /usr/src/ https://rpm5.org/files/popt/popt-${VERSION}.tar.gz
RUN cd /usr/src/ && tar xf popt*
RUN cd /usr/src/popt* \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --prefix=/usr \
    --libdir=/lib \
    --disable-static \
    && make

RUN cd /usr/src/popt* \
    && make install
