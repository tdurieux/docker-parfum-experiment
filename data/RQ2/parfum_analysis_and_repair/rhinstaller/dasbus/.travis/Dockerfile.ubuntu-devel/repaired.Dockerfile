FROM ubuntu:devel
ENV LANG=C.utf8

# Disable interaction with tzdata.
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    make \
    python3 \
    python3-pip \
    python3-gi \
    dbus-daemon \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir \
    sphinx \
    sphinx_rtd_theme \
    coverage \
    pylint
