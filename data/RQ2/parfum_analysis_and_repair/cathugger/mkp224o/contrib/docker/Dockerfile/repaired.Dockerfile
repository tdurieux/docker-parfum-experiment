FROM alpine:3.12.0

LABEL maintainer="sstefin@bk.ru"

#Installing all the dependencies
RUN apk add --no-cache gcc libsodium-dev make autoconf build-base

WORKDIR /mkp224o

COPY . /mkp224o/

RUN ./autogen.sh \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && cp /mkp224o/mkp224o /usr/local/bin/

VOLUME /root/data

WORKDIR /root/data

ENTRYPOINT ["mkp224o"]
