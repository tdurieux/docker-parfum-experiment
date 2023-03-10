#
# In order to work you need to mount the source directory containing
# the configured greyd you wish to build to /home/builder/source and
# the rpm output to /home/builder/rpm.
#

FROM centos:7

RUN yum install -y epel-release && \
        yum install -y \
        gcc \
        gcc-c++ \
        libtool \
        libtool-ltdl \
        make \
        pkgconfig \
        automake \
        autoconf \
        yum-utils \
        libtool-ltdl-devel \
        zlib-devel \
        openssl-devel \
        libdb-devel \
        libcap-devel \
        ipset-devel \
        libmnl-devel \
        libnetfilter_conntrack-devel \
        libnetfilter_log-devel \
        libspf2-devel \
        sqlite-devel \
        rpm-build && yum clean all && rm -rf /var/cache/yum

RUN useradd builder -u 1000 -m -G users,wheel && \
    echo "builder ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "# macros"                      >  /home/builder/.rpmmacros && \
    echo "%_topdir    /home/builder/rpm" >> /home/builder/.rpmmacros && \
    mkdir -p /home/builder/rpm/{BUILD{,ROOT},RPMS,SOURCES,SPECS,SRPMS} && \
    chown -R builder /home/builder && \
    mkdir /home/builder/source
USER builder

ENV FLAVOR=rpmbuild OS=centos DIST=el7
CMD cd /home/builder/source && make rpm
