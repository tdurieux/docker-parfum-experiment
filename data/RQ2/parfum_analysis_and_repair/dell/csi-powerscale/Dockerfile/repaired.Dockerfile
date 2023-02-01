ARG GOPROXY

FROM rockylinux:8
ARG GOPROXY

RUN yum install -y libaio libuuid numactl xfsprogs e4fsprogs nfs-utils && rm -rf /var/cache/yum

RUN yum clean all
COPY "csi-isilon" .
ENTRYPOINT ["/csi-isilon"]
