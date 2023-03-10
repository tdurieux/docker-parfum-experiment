FROM alpine:latest

RUN apk --no-cache add --virtual .build-dependencies \
  autoconf \
  automake \
  confuse-dev \
  gcc \
  gnutls-dev \
  libc-dev \
  libtool \
  make

WORKDIR /root
COPY . ./
RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --sysconfdir=/etc --localstatedir=/var && make install


FROM alpine:latest

RUN apk --no-cache add \
  ca-certificates \
  confuse \
  gnutls

COPY --from=0 /usr/sbin/inadyn /usr/sbin/inadyn
COPY --from=0 /usr/share/doc/inadyn /usr/share/doc/inadyn
ENTRYPOINT ["/usr/sbin/inadyn", "--foreground"]
