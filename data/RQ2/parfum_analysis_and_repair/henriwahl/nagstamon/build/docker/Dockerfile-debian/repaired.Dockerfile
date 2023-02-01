FROM debian:8
LABEL maintainer=henri@nagstamon.de

RUN apt -y update
RUN apt -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;

# python3-pysocks in debian:8 becomes python3-socks in later versions
RUN apt -y --no-install-recommends install debhelper \
                   fakeroot \
                   git \
                   make \
                   libqt5multimedia5-plugins \
                   python3-bs4 \
                   python3-dateutil \
                   python3-dbus.mainloop.pyqt5 \
                   python3-keyring \
                   python3-lxml \
                   python3-pkg-resources \
                   python3-psutil \
                   python3-pyqt5 \
                   python3-pyqt5.qtsvg \
                   python3-pyqt5.qtmultimedia \
                   python3-requests \
                   python3-requests-kerberos \
                   python3-setuptools \
                   python3-pysocks && rm -rf /var/lib/apt/lists/*;

CMD cd /nagstamon/build && \
    /usr/bin/python3 build.py