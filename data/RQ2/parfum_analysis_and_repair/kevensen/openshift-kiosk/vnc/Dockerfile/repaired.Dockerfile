# Using CentOS 6 base image and VNC
# Version 1

# Pull the rhel image from the local repository
FROM centos:7
MAINTAINER Ken Evensen

LABEL io.openshift.expose-services="5901:tcp"

USER root
ENV DISPLAY="" \
    HOME=/home/1001

ARG vncpassword=password

RUN yum clean all && \
    yum update -y && \
    yum install -y --setopt=tsflags=nodocs \
                   tigervnc-server \
    		   xorg-x11-server-utils \
                   xorg-x11-server-Xvfb \
                   xorg-x11-fonts-* \
                   xterm && \
                   yum clean all && \
                   rm -rf /var/cache/yum

RUN yum install -y --setopt=tsflags=nodocs \
                  openmotif \
                  xterm \
                  firefox \
                  yum clean all && \
                  rm -rf /var/cache/yum/*

RUN /bin/dbus-uuidgen --ensure
RUN useradd -u 1001 -r -g 0 -d ${HOME} -s /bin/bash -c "Kiosk User" kioskuser

ADD xstartup ${HOME}/.vnc/
RUN echo "${vncpassword}" | vncpasswd -f > ${HOME}/.vnc/passwd
# RUN /bin/echo "/usr/bin/firefox" >> /home/1001/.vnc/xstartup