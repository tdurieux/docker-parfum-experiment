FROM ubuntu:18.10

MAINTAINER Laurent Gautier <lgautier@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive
ARG CRAN_MIRROR=https://cran.revolutionanalytics.com/
ARG CRAN_MIRROR_TAG=-cran35

COPY install_apt.sh /opt/
COPY install_rpacks.sh /opt/
COPY install_pip.sh /opt/

RUN \
  sh /opt/install_apt.sh && \
  sh /opt/install_rpacks.sh && \
  sh /opt/install_pip.sh
  
# Run dev version of rpy2
RUN \
  python3 -m pip --no-cache-dir install \
       https://bitbucket.org/rpy2/rpy2/get/default.tar.gz && \
  rm -rf /root/.cache

