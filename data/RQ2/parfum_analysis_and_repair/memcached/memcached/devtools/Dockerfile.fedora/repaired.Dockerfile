FROM fedora:latest

ARG CONFIGURE_OPTS="--enable-seccomp"

RUN dnf install -y perl automake autoconf libseccomp-devel libevent-devel gcc make git

RUN useradd -ms /bin/bash memcached
ADD . /src
WORKDIR /src

RUN aclocal && autoheader && automake --foreign --add-missing && autoconf
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" ${CONFIGURE_OPTS}
RUN make -j

USER memcached

CMD make test
