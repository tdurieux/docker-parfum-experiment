FROM thushear/java:1.0
MAINTAINER thushear <lucas421634258@gmail.com>

# The used storm version can also be supplied like this with the build command like this:
# --build-arg BIN_VERSION=apache-storm-1.0.2
ARG BIN_VERSION=apache-storm-1.0.0

WORKDIR /usr/share/storm

# supervisor: worker ports
EXPOSE 6700 6701 6702 6703
# logviewer
EXPOSE 8000
# DRPC and remote deployment
EXPOSE 6627 3772 3773

# Install and set everything up
RUN \
   alias python=python3 \
&& apt-get update -y \
&& apt-get install --no-install-recommends -y \
   python \
&& wget -q -N https://mirrors.aliyun.com/apache/storm/${BIN_VERSION}/${BIN_VERSION}.tar.gz \
&& tar --strip-components=1 -C /usr/share/storm -xvf ${BIN_VERSION}.tar.gz \
&& rm ${BIN_VERSION}.tar.gz \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add startup script
ADD entrypoint.sh entrypoint.sh
ADD cluster.xml log4j2/cluster.xml
ADD worker.xml log4j2/worker.xml
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/usr/share/storm/entrypoint.sh"]
