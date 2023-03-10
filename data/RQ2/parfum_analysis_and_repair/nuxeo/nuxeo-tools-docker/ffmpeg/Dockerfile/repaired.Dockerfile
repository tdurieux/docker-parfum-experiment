# Ubuntu base with ffmpeg packager
#
# VERSION               0.0.1

FROM       debian:wheezy
MAINTAINER Nuxeo Packagers <packagers@nuxeo.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -q --no-install-recommends -y install wget && rm -rf /var/lib/apt/lists/*;
RUN echo "deb http://www.deb-multimedia.org wheezy main non-free" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -q --no-install-recommends -y --force-yes install deb-multimedia-keyring && rm -rf /var/lib/apt/lists/*;
RUN apt-get update

RUN apt-get -q -y upgrade

# Install basic tools
RUN apt-get -q --no-install-recommends -y install git wget sudo && rm -rf /var/lib/apt/lists/*;

# Add build script
ADD package-all.sh /usr/local/src/package-all.sh
RUN chmod +x /usr/local/src/package-all.sh

ENTRYPOINT ["/usr/local/src/package-all.sh"]

