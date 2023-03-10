FROM strato-build

ENV VERSION 0.1.10
ENV LDFLAGS -s
RUN wget -P /usr/src/ https://libestr.adiscon.com/files/download/libestr-${VERSION}.tar.gz
RUN cd /usr/src/ && tar xf libestr*
RUN cd /usr/src/libestr* \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --prefix=/usr \
    && make

RUN cd /usr/src/libestr* \
    && make install
