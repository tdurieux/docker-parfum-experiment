# BUILDING
# docker build -t comskip-build .
#
# RUNNING
# docker run -t -i -v /tmp:/build comskip-build
#
# DESCRIPTION
# Simple
FROM phusion/baseimage

MAINTAINER Sean Stuckless <sean.stuckless@gmail.com>

ENV APP_NAME="SageTV Comskip Builder"
ENV DEBIAN_FRONTEND noninteractive

# Speed up APT
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup \
  && echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

# Install dependencies
RUN set -x
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y build-essential pkg-config git bzip2 wget xz-utils libargtable2-dev yasm && rm -rf /var/lib/apt/lists/*;

RUN apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* *.deb

RUN mkdir /build
RUN mkdir /sources
ADD buildcomskip.sh /usr/bin/
ADD argtable2-13.tar.gz /sources/

# need to passed on the command line as the place to fetch and build the source
# -v full_path_to_local_empty_dir_where_sources_will_be_built:/build
VOLUME ["/build"]

WORKDIR /build

CMD buildcomskip.sh
