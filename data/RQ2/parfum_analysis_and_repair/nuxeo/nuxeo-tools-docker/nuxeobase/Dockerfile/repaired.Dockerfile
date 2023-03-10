# Nuxeo Base image is a ubuntu precise image with all the dependencies needed by Nuxeo Platform
#
# VERSION               0.0.1

FROM      ubuntu:precise
MAINTAINER Laurent Doguin <ldoguin@nuxeo.com>


# Set locale
RUN locale-gen --no-purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Install dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install --no-install-recommends -y python-software-properties wget sudo net-tools && rm -rf /var/lib/apt/lists/*;


RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

# Add Nuxeo Repository
RUN apt-add-repository "deb http://apt.nuxeo.org/ precise fasttracks"
RUN wget -q -O - https://apt.nuxeo.org/nuxeo.key | apt-key add -

# Upgrade Ubuntu
RUN apt-get update
RUN apt-get upgrade -y


# Small trick to Install fuse(libreoffice dependency) because of container permission issue.
RUN apt-get -y --no-install-recommends install fuse || true && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/dpkg/info/fuse.postinst
RUN apt-get -y --no-install-recommends install fuse && rm -rf /var/lib/apt/lists/*;

# Install Nuxeo Dependencies
RUN sudo apt-get install --no-install-recommends -y acpid openjdk-7-jdk libreoffice imagemagick poppler-utils ffmpeg ffmpeg2theora ufraw libwpd-tools perl locales pwgen dialog supervisor unzip vim && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /var/log/supervisor

# create Nuxeo user
RUN useradd -m -d /home/nuxeo -p nuxeo nuxeo && adduser nuxeo sudo && chsh -s /bin/bash nuxeo
ENV NUXEO_USER nuxeo
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
