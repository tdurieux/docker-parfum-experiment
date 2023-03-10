FROM nvidia/cuda:10.1-devel-centos7 as builder
RUN echo "UPDATE" && yum -y update
RUN echo "DEVTOOLS" && yum -y install \
    git \
    gcc \
    make \
    rpm-build && rm -rf /var/cache/yum
RUN echo "EXTRAS" && yum -y install \
    libpcap-devel \
    openssl-devel && rm -rf /var/cache/yum
RUN mkdir /packages && chown 777 /packages
COPY build_hsflowd /root/build_hsflowd
ENTRYPOINT ["/root/build_hsflowd"]
