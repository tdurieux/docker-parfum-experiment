FROM centos:7

RUN yum install -y smartmontools lsscsi e4fsprogs && rm -rf /var/cache/yum

COPY ./_build/local-disk-manager /local-disk-manager

ENTRYPOINT [ "/local-disk-manager" ]
