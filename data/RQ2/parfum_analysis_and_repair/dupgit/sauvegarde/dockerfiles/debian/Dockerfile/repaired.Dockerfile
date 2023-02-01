FROM debian:8

LABEL maintainer="Olivier Delhomme <olivier.delhomme@free.fr>"

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/

RUN apt-get -y update; \
    apt-get -y --no-install-recommends install apt-utils; \
    apt-get -y --no-install-recommends install bash git autoconf automake libtool make libsqlite3-dev  libglib2.0-dev libmicrohttpd-dev libcurl4-gnutls-dev intltool; \
    git clone git://github.com/akheron/jansson.git; cd jansson; autoreconf -f -i; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-silent-rules; make; make install; cd ..; rm -fr jansson; \
    apt-get clean all && rm -f /var/lib/apt/lists/*;


# Compiling sauvegarde project.
RUN git clone https://github.com/dupgit/sauvegarde.git; cd sauvegarde; ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make check && make install;
