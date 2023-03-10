FROM debian:stable
MAINTAINER Mauro <mauro@sdf.org>

###
# Building env
#

ENV LANG C.UTF-8
ENV USER root
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes
ENV QUILT_PATCHES=debian/patches

###
# Distro setup: Sources repositories & SC build dependencies
#

RUN echo "deb-src http://deb.debian.org/debian stable main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get install -yq \
    devscripts git-buildpackage \
    ca-certificates quilt \
    libwww-perl gnupg2 \
    file pristine-tar fakeroot \
    --no-install-recommends \
    && apt-get build-dep -yq supercollider && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
