FROM centos:7

RUN yum install -y xfsprogs udev smartmontools lsscsi && rm -rf /var/cache/yum

COPY ./_build/local-storage /

ENTRYPOINT [ "/local-storage" ]
