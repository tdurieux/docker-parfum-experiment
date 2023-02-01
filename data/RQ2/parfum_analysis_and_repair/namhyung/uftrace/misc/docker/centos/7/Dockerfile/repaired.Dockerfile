FROM centos:7
ARG test
RUN yum install -y git gcc make epel-release && rm -rf /var/cache/yum
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*

# update gcc  version
RUN yum install -y centos-release-scl && rm -rf /var/cache/yum
RUN yum install -y devtoolset-9-gcc* devtoolset-9-libasan-devel devtoolset-9-libubsan-devel && rm -rf /var/cache/yum
RUN echo "source /opt/rh/devtoolset-9/enable" >> /etc/bashrc
SHELL ["/bin/bash", "--login", "-c"]

RUN mkdir -p /usr/src && rm -rf /usr/src
RUN git clone https://github.com/namhyung/uftrace /usr/src/uftrace
RUN if [ "$test" = "yes" ] ; then \
        cd /usr/src/uftrace \
        && ./misc/install-deps.sh -y \
        && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make ASAN=1 && make ASAN=1 unittest; \
    else \
        cd /usr/src/uftrace && ./misc/install-deps.sh -y && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install; \
    fi
