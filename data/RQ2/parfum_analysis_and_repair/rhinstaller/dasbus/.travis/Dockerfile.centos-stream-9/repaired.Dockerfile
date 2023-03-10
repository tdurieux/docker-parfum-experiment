FROM quay.io/centos/centos:stream9
ENV LANG=C.utf8

RUN yum -y update; \
    yum -y install \
    make \
    python3 \
    python3-pip \
    python3-gobject-base \
    dbus-daemon; rm -rf /var/cache/yum \
    yum clean all

RUN pip3 install --no-cache-dir \
    sphinx \
    sphinx_rtd_theme \
    coverage \
    pylint
