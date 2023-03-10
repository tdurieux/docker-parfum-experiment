FROM registry.centos.org/centos/centos:7

# base: EPEL repo for extra tools
RUN yum -y install epel-release && rm -rf /var/cache/yum

# build: system utilities and libraries
RUN yum update -y && \
    yum -y install epel-release && \
    yum -y groupinstall 'Development Tools' && \
    yum -y install openssl-devel protobuf-compiler jq podman && \
    yum -y install yamllint && \
    yum -y install cmake elfutils-libelf-devel libcurl-devel binutils-devel elfutils-devel && \
    yum clean all && rm -rf /var/cache/yum

