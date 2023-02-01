FROM centos:6
ENV HOME /
RUN yum update -y
RUN yum install -y rpm-build redhat-rpm-config rpmdevtools cmake gcc-c++ tar openssl-devel bison automake libtool git centos-release-scl && rm -rf /var/cache/yum
RUN yum install -y rh-ruby23 rh-ruby23-scldevel && rm -rf /var/cache/yum
ADD ./deps /deps
RUN cd /deps \
    && LIBUV_VERSION="$(ls libuv-v*.tar.gz | sed -e 's/libuv-v\(.*\)\.tar\.gz/\1/' | sort -r | head -n1)" \
    && tar xzf "libuv-v${LIBUV_VERSION}.tar.gz" \
    && cd "libuv-${LIBUV_VERSION}" \
    && sh autogen.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --libdir="$([ $(getconf LONG_BIT) -eq 64 ] && echo -n /usr/lib64 || echo -n /usr/lib)" \
    && make \
    && make check \
    && make install && rm "libuv-v${LIBUV_VERSION}.tar.gz"
RUN rpmdev-setuptree
RUN echo '%dist   .el6' >> /.rpmmacros
ADD ./rpmbuild/ /rpmbuild/
RUN chown -R root:root /rpmbuild
RUN scl enable rh-ruby23 -- rpmbuild -ba /rpmbuild/SPECS/h2o.spec
RUN tar -czf /tmp/h2o.tar.gz -C /rpmbuild RPMS SRPMS && rm /tmp/h2o.tar.gz
CMD ["/bin/true"]
