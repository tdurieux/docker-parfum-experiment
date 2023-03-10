FROM centos:7

RUN yum update -y
RUN yum -y groupinstall "Development Tools" && \
    yum -y install centos-release-scl && \
    yum -y install llvm-toolset-7.0 elfutils-libelf-devel \
    ; rm -rf /var/cache/yum

RUN mkdir -p /output
COPY build-kos /scripts/
COPY build-wrapper.sh /usr/bin/
COPY prepare-src /usr/bin

COPY redhat-entrypoint.sh /redhat-entrypoint.sh

WORKDIR /scratch
ENTRYPOINT [ "/redhat-entrypoint.sh" ]
