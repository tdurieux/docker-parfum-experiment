# Create a Docker image that is ready to run the main Randoop tests,
# using JDK 11.

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
  openjdk-11-jdk \
&& update-java-alternatives --set java-1.11.0-openjdk-amd64 && rm -rf /var/lib/apt/lists/*;

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy --no-install-recommends install \
  curl \
  git \
  gradle \
  jq \
  maven \
  python3-requests \
  xvfb \
&& apt-get -qqy update \
&& apt-get -qqy --no-install-recommends install \
  python3-pip \
&& pip3 install --no-cache-dir html5validator && rm -rf /var/lib/apt/lists/*;

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
