##FROM hilbert/base##
FROM ubuntu:19.04

MAINTAINER Oleksandr Motsak <malex984+hilbert.xpra@gmail.com>

COPY update.sh upgrade.sh install.sh clean.sh setup_ogl.sh /usr/local/bin/

RUN update.sh && install.sh wget software-properties-common dirmngr --install-recommends && clean.sh

RUN apt-key adv --fetch-keys https://winswitch.org/gpg.asc
RUN cd /etc/apt/sources.list.d/ && wget https://xpra.org/repos/disco/xpra.list

RUN update.sh \
&& install.sh xpra pulseaudio pavucontrol gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-pulseaudio python-gst-1.0 python-websockify websockify python-xdg python2.7-dbus python2.7-gi python2.7-netifaces python2.7-paramiko xpra-html5 --install-recommends \
&& clean.sh

# VOLUME /tmp/.X11-unix/
COPY pa.sh /usr/local/bin/

# ENV HOME /root
# RUN mkdir "$HOME/.vnc"
# Setup a password
# RUN x11vnc -storepasswd 1234 ~/.vnc/passwd

# x11vnc -usepw -forever

EXPOSE 5990-5999

# CMD [""]
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]



ARG IMAGE_VERSION=latest
ARG GIT_NOT_CLEAN_CHECK
# Build-time metadata as defined at http://label-schema.org