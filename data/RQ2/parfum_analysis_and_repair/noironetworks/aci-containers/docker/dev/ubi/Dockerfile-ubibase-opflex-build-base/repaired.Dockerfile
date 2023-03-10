FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
RUN microdnf install --enablerepo codeready-builder-for-rhel-8-x86_64-rpms \
    libtool pkgconfig autoconf automake make cmake file python2-six \
    openssl-devel git gcc gcc-c++ boost-devel diffutils python2-devel \
    libnetfilter_conntrack-devel wget which curl-devel procps zlib-devel \
    libmnl-devel vi \
    && microdnf clean all
CMD ["/usr/bin/sh"]