FROM ubuntu:latest

ARG CONFIGURE_OPTS="--enable-seccomp"

RUN apt-get update && apt-get install --no-install-recommends -y build-essential automake1.11 autoconf libevent-dev libseccomp-dev git && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash memcached
ADD . /src
WORKDIR /src

RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" ${CONFIGURE_OPTS}
RUN make -j

USER memcached

CMD make test
