# Using the VNC image to run Eclipse
# Version 1

FROM kevensen/centos-vnc

MAINTAINER Kenneth D. Evensen <kevensen@redhat.com>

USER root

RUN yum update -y && \
   yum groupinstall -y Eclipse && \
   yum clean all && \
   rm -rf /var/cache/yum

RUN /bin/echo "/usr/bin/eclipse" >> /home/1001/.vnc/xstartup 

USER kioskuser
