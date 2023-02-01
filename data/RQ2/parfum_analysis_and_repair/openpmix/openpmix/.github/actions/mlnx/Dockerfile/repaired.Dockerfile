FROM centos:7.6.1810

RUN \
    yum install -y perl perl-Data-Dumper \
        automake libtool flex make bzip2 git which rpm-build libevent-devel pandoc hwloc hwloc-devel && rm -rf /var/cache/yum

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

