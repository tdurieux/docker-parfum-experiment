FROM ubuntu:jammy
MAINTAINER Log2Timeline <log2timeline-dev@googlegroups.com>

# Create container with:
# docker build --no-cache --build-arg PPA_TRACK="[dev|stable]" \
#   --force-rm -t log2timeline/plaso .
#
# Run log2timeline on artifacts stored in /data/artifacts with:
# docker run -ti -v /data/:/data/ <container_id> log2timeline \
#   /data/results/result.plaso /data/artifacts

ARG PPA_TRACK=stable

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install apt-transport-https apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libterm-readline-gnu-perl software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:gift/$PPA_TRACK

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get -y --no-install-recommends install locales plaso-tools && rm -rf /var/lib/apt/lists/*;

# Clean up apt-get cache files
RUN apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/*

# Set terminal to UTF-8 by default
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

WORKDIR /usr/local/bin
COPY "plaso-switch.sh" "plaso-switch.sh"
RUN chmod a+x plaso-switch.sh

VOLUME ["/data"]

WORKDIR /home/plaso/

ENTRYPOINT ["/usr/local/bin/plaso-switch.sh"]
