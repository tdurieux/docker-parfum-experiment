FROM centos:centos7
MAINTAINER Raghavendra Prabhu raghavendra.prabhu@percona.com
RUN yum install -y git automake gcc make g++ libtool autoconf pkgconfig gettext mysql-libs mariadb-devel rsync && rm -rf /var/cache/yum
RUN git clone --depth=1 https://github.com/akopytov/sysbench
WORKDIR /sysbench
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install
RUN mkdir -p /usr/share/doc/sysbench/tests/
RUN rsync -a sysbench/tests/db  /usr/share/doc/sysbench/tests/
