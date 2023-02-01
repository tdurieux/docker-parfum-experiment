FROM centos:7

WORKDIR /tmp

RUN rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
RUN yum -y install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm && rm -rf /var/cache/yum
RUN yum -y install epel-release && rm -rf /var/cache/yum

RUN yum -y install autoconf automake pkg-config && rm -rf /var/cache/yum
RUN yum -y install libattr-devel libblkid-devel libuuid-devel && rm -rf /var/cache/yum
RUN yum -y install e2fsprogs-libs e2fsprogs-devel reiserfs-utils && rm -rf /var/cache/yum
RUN yum -y install zlib-devel lzo-devel libzstd-devel zstd-devel zstd && rm -rf /var/cache/yum
RUN yum -y install make gcc tar gzip clang && rm -rf /var/cache/yum
RUN yum -y install python3 python3-devel python3-setuptools && rm -rf /var/cache/yum

# For downloading fresh sources
RUN yum -y install wget && rm -rf /var/cache/yum

# For running tests
RUN yum -y install coreutils util-linux e2fsprogs findutils grep && rm -rf /var/cache/yum
RUN yum -y install udev device-mapper acl attr xz && rm -rf /var/cache/yum

# For debugging
RUN yum -y install less vim && rm -rf /var/cache/yum

COPY ./test-build .
COPY ./run-tests .
COPY ./devel.tar.gz .

CMD ./test-build devel --disable-documentation

# Continue with:
# cd /tmp
# (see CMD above)
# ./run-tests /tmp/btrfs-progs-devel
