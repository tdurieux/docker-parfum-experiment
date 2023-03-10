FROM quay.io/luet/base:latest
ADD conf/luet.yaml.docker /etc/luet/luet.yaml
ADD conf/repos.conf.d/ /etc/luet/repos.conf.d

ENV USER=root

SHELL ["/usr/bin/luet", "install", "-d", "-y"]

RUN repository/luet
RUN repository/mocaccino-micro
RUN utils/busybox-static
RUN system/musl-toolchain
RUN system/musl-compat

SHELL ["/bin/sh", "-c"]
RUN rm -rf /var/cache/luet/packages/ /var/cache/luet/repos/

ENV TMPDIR=/tmp
ENTRYPOINT ["/bin/sh"]