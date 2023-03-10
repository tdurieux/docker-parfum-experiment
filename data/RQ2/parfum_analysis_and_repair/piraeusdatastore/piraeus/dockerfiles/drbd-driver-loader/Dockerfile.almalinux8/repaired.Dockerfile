FROM almalinux:8
MAINTAINER Roland Kammerer <roland.kammerer@linbit.com>

ARG DRBD_VERSION

RUN yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical && \
	yum install -y wget gcc make patch curl elfutils-libelf-devel kmod && yum clean all -y && rm -rf /var/cache/yum

RUN wget https://pkg.linbit.com/downloads/drbd/9/drbd-${DRBD_VERSION}.tar.gz -O /drbd.tar.gz && \
    wget https://raw.githubusercontent.com/LINBIT/drbd/master/docker/entry.sh -O /entry.sh && chmod +x /entry.sh

ENV LB_HOW compile
ENTRYPOINT /entry.sh
