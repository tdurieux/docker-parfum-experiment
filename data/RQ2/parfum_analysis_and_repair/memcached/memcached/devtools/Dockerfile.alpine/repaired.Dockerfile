FROM alpine:latest

ARG CONFIGURE_OPTS="--enable-seccomp"

RUN apk update && apk add --no-cache musl-dev libevent-dev libseccomp-dev linux-headers gcc make automake autoconf perl-test-harness-utils git

RUN adduser -S memcached
ADD . /src
WORKDIR /src

RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" ${CONFIGURE_OPTS}
RUN make -j

USER memcached

CMD make test
