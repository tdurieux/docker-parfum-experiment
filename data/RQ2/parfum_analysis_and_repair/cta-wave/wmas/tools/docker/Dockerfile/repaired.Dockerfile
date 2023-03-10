FROM ubuntu:18.04

# No interactive frontend during docker build
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

# General requirements not in the base image
RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    bzip2 \
    ca-certificates \
    dbus-x11 \
    earlyoom \
    gdebi \
    git \
    locales \
    pulseaudio \
    python \
    python-pip \
    tzdata \
    sudo \
    unzip \
    wget \
    xvfb && rm -rf /var/lib/apt/lists/*;

# Installing just the deps of firefox and chrome is moderately tricky, so
# just install the default versions of them, and some extra deps we happen
# to know that chrome requires

RUN apt-get -qqy --no-install-recommends install \
    firefox \
    libnss3-tools \
    fonts-liberation \
    indicator-application \
    libappindicator1 \
    libappindicator3-1 \
    libdbusmenu-gtk3-4 \
    libindicator3-7 \
    libindicator7 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir virtualenv

ENV TZ "UTC"
RUN echo "${TZ}" > /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata

RUN useradd test \
         --shell /bin/bash  \
         --create-home \
  && usermod -a -G sudo test \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'test:secret' | chpasswd

ENV SCREEN_WIDTH 1280
ENV SCREEN_HEIGHT 1024
ENV SCREEN_DEPTH 24
ENV DISPLAY :99.0

USER test

WORKDIR /home/test

# Remove information on how to use sudo on login
RUN sudo echo ""

RUN mkdir -p /home/test/artifacts

WORKDIR /home/test/

COPY .bashrc /home/test/.bashrc

COPY start.sh /home/test/start.sh
