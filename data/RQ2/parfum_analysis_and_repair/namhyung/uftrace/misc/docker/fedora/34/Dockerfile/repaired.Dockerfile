FROM fedora:34
ARG test
RUN yum install -y git gcc make && rm -rf /var/cache/yum
RUN mkdir -p /usr/src && rm -rf /usr/src
RUN git clone https://github.com/namhyung/uftrace /usr/src/uftrace
RUN if [ "$test" = "yes" ] ; then \
        cd /usr/src/uftrace \
        && ./misc/install-deps.sh -y \
        && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make ASAN=1 && make ASAN=1 unittest; \
    else \
        cd /usr/src/uftrace && ./misc/install-deps.sh -y && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install; \
    fi
