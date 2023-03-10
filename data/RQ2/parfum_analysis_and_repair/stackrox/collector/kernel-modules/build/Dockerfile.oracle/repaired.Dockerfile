FROM oraclelinux:7

RUN yum -y update && yum -y install yum-utils && \
    yum-config-manager --enable ol7_UEKR6 && \
    yum -y install \
    git \
    wget \
    gcc \
    gcc-c++ \
    autoconf \
    make \
    cmake \
    libdtrace-ctf \
    elfutils-libelf-devel \
    file \
    python-lxml && \
    yum-config-manager --add-repo=http://yum.oracle.com/public-yum-ol7.repo && \
    yum-config-manager --enable ol7_developer --enable ol7_developer_EPEL && \
    yum install -y rh-dotnet20-clang rh-dotnet20-llvm && rm -rf /var/cache/yum

RUN mkdir -p /output
COPY build-kos /scripts/
COPY build-wrapper.sh /usr/bin/
COPY prepare-src /usr/bin

COPY oracle-entrypoint.sh /oracle-entrypoint.sh

WORKDIR /scratch
ENTRYPOINT [ "/oracle-entrypoint.sh" ]
