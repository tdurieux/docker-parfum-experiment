FROM centos:7

LABEL maintainer="Olivier Delhomme <olivier.delhomme@free.fr>"

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/

RUN yum -y update; \
    yum -y install file git autoconf automake libtool make sqlite-devel glib2-devel libmicrohttpd-devel libcurl-devel intltool; rm -rf /var/cache/yum \
    git clone git://github.com/akheron/jansson.git; cd jansson; autoreconf -f -i; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-silent-rules; make; make install; cd ..; rm -fr jansson;

RUN git clone https://github.com/dupgit/sauvegarde.git; cd sauvegarde; ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make check && make install;

