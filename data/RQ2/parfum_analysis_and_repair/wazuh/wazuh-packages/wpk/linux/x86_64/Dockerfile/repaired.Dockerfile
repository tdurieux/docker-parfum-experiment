FROM centos:6

RUN rm /etc/yum.repos.d/* && echo "exactarch=1" >> /etc/yum.conf
COPY CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

RUN yum -y install epel-release && \
    yum -y install gcc make git python34 python34-pip python34-devel python34-cffi \
    jq sudo gnupg automake \
    autoconf wget libtool policycoreutils-python \
    yum-utils epel-release redhat-rpm-config rpm-devel \
    autopoint gettext nspr nspr-devel \
    nss nss-devel kenel-headers magic magic-devel \
    db4 db4-devel zlib zlib-devel rpm-build bison \
    sharutils bzip2-devel xz-devel lzo-devel \
    e2fsprogs-devel libacl-devel libattr-devel \
    openssl-devel libxml2-devel kexec-tools elfutils \
    libarchive-devel elfutils-libelf-devel \
    elfutils-libelf patchelf elfutils-devel libgcrypt-devel && rm -rf /var/cache/yum

RUN yum-builddep python34 -y

RUN curl -f -OL https://packages.wazuh.com/utils/gcc/gcc-9.4.0.tar.gz && \
    tar xzf gcc-9.4.0.tar.gz && cd gcc-9.4.0/ && \
    ./contrib/download_prerequisites && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/gcc-9.4.0 --enable-languages=c,c++ \
        --disable-multilib --disable-libsanitizer && \
    make -j$(nproc) && make install && \
    ln -fs /usr/local/gcc-9.4.0/bin/g++ /usr/bin/c++ && cd / && rm -rf gcc-* && rm gcc-9.4.0.tar.gz

ENV CPLUS_INCLUDE_PATH "/usr/local/gcc-9.4.0/include/c++/9.4.0/"
ENV LD_LIBRARY_PATH "/usr/local/gcc-9.4.0/lib64/"
ENV PATH "/usr/local/gcc-9.4.0/bin:${PATH}"

RUN curl -f -OL https://packages.wazuh.com/utils/cmake/cmake-3.18.3.tar.gz && \
    tar -zxf cmake-3.18.3.tar.gz && cd cmake-3.18.3 && \
    ./bootstrap --no-system-curl CC=/usr/local/gcc-9.4.0/bin/gcc \
        CXX=/usr/local/gcc-9.4.0/bin/g++ && \
    make -j$(nproc) && make install && cd / && rm -rf cmake-* && rm cmake-3.18.3.tar.gz

RUN curl -f -OL https://packages.wazuh.com/utils/openssl/openssl-1.1.1a.tar.gz && \
    tar xf openssl-1.1.1a.tar.gz && cd openssl-1.1.1a && \
    ./config --prefix=/usr/ --openssldir=/usr/ shared zlib && \
    make -j$(nproc) && make install && echo "/usr/lib" > /etc/ld.so.conf.d/openssl-1.1.1a.conf && \
    ldconfig -v && cd / && rm -rf openssl-1.1.1a* && rm openssl-1.1.1a.tar.gz

RUN pip3 install --no-cache-dir cryptography==2.9.2 typing awscli
RUN pip3 install --no-cache-dir --upgrade botocore==1.20.54

ADD wpkpack.py /usr/local/bin/wpkpack
ADD run.sh /usr/local/bin/run
ENTRYPOINT ["/usr/local/bin/run"]
