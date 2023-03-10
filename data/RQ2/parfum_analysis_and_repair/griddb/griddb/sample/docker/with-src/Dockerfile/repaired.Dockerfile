FROM centos:7

RUN yum install -y zip unzip zlib-devel ant \
    && yum groupinstall -y "Development Tools" \
    && yum clean all && rm -rf /var/cache/yum

RUN cd /root/ \
    && git clone https://github.com/griddb/griddb_nosql.git \
    && cd griddb_nosql \
    && ./bootstrap.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && rm -rf *.o

VOLUME /root/griddb_nosql

ENV GS_HOME=/root/griddb_nosql
ENV GS_LOG=/root/griddb_nosql/log
