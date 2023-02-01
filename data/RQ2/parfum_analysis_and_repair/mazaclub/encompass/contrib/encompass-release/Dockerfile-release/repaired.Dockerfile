FROM ubuntu:15.04
MAINTAINER Rob Nelson <guruvan@maza.club>
ENV BUILDER_VER 1.2

VOLUME ["/opt/wine-electrum/drive_c/encompass"]

RUN apt-get update -y && apt-get install --no-install-recommends -y software-properties-common curl wget \
        git python-pip pyqt4-dev-tools zip unzip python-dev \
	python-all python-all-dev debhelper \
        cython libusb-1.0-0-dev libudev-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir stdeb
RUN  git clone https://github.com/pyinstaller/pyinstaller \
       && cd pyinstaller \
       && python setup.py install
RUN  adduser --disabled-password --gecos "build" build
RUN  apt-get purge -y python-software-properties
RUN  apt-get autoclean -y



