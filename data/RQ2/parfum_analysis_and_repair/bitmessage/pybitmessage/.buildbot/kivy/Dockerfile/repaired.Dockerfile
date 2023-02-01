# A container for buildbot
FROM ubuntu:bionic AS kivy
# FROM ubuntu:20.04 AS buildbot-bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -yq python-setuptools \
    python-setuptools libssl-dev libpq-dev python-prctl python-dev \
    python-virtualenv python-pip virtualenv \
    libjpeg-dev zlib1g-dev python3-dev \
    python3-virtualenv \
    python3-pip \
    wget \
    build-essential libcap-dev libmtdev-dev xvfb xclip git python3-opencv && rm -rf /var/lib/apt/lists/*;

RUN ln -sf /usr/bin/python3 /usr/bin/python

RUN pip3 install --no-cache-dir Cython Pillow pyzbar telenium

RUN pip3 install --no-cache-dir --upgrade setuptools pip

RUN pip3 install --no-cache-dir -e git+https://github.com/kivymd/KivyMD#egg=kivymd
