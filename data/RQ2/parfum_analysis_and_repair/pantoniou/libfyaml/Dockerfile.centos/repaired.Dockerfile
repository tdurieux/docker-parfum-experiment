ARG IMAGE=centos
FROM ${IMAGE}
# install build dependencies
RUN yum update -y
RUN yum install -y gcc autoconf automake libtool git make pkgconf && rm -rf /var/cache/yum
# configure argument
ARG CONFIG_ARGS
ENV CONFIG_ARGS=${CONFIG_ARGS:-"--enable-debug --prefix=/usr"}
COPY . /build
WORKDIR /build
# do a maintainer clean if the directory was unclean (it can fail)
RUN make maintainer-clean >/dev/null 2>&1|| true
RUN ./bootstrap.sh 2>&1
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" 2>&1 ${CONFIG_ARGS}
RUN make
# NOTE: no check, since alpine it's only a build test distro
