FROM registry.fedoraproject.org/fedora:rawhide
ENV LANG=C.utf8

RUN dnf -y update; \
    dnf -y install \
    gcc \
    make \
    python3 \
    python3-pip \
    python3-wheel \
    python3-gobject-base \
    dbus-daemon; \
    dnf clean all

RUN pip3 install --no-cache-dir \
    sphinx \
    sphinx_rtd_theme \
    coverage \
    pylint
