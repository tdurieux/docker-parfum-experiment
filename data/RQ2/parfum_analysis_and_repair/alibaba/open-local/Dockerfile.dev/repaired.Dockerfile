FROM centos:7
RUN yum install -y file xfsprogs e4fsprogs lvm2 util-linux && rm -rf /var/cache/yum
COPY bin/open-local /bin/open-local
ENTRYPOINT ["open-local"]