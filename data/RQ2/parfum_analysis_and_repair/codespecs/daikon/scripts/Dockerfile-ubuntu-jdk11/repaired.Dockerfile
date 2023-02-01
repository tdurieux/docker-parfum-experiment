# Create a Docker image that is ready to run the Daikon tests,
# using JDK 8.

# "ubuntu" is the latest LTS release.  "ubuntu:rolling" is the latest release.
FROM ubuntu
MAINTAINER Michael Ernst <mernst@cs.washington.edu>

# According to
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/:
#  * Put "apt-get update" and "apt-get install" in the same RUN command.
#  * Do not run "apt-get upgrade"; instead get upstream to update.

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy --no-install-recommends install \
  autoconf \
  automake \
  bc \
  binutils-dev \
  ctags \
  gcc \
  git \
  graphviz \
  jq \
  m4 \
  make \
  netpbm \
  rsync \
  unzip && rm -rf /var/lib/apt/lists/*;

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy --no-install-recommends install \
  openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;

# These are needed to build the Checker Framework, used by the "typecheck" job in CI.
RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy --no-install-recommends install \
  ant \
  maven \
  python \
  python3 && rm -rf /var/lib/apt/lists/*;

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
