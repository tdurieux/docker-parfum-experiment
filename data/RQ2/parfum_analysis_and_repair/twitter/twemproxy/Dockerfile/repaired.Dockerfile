FROM gcc

COPY . /usr/src/twemproxy
WORKDIR /usr/src/twemproxy
RUN \
  autoreconf -h && \
  autoreconf -fvi && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
  make && \
  make install

ENTRYPOINT [ "nutcracker" ]
