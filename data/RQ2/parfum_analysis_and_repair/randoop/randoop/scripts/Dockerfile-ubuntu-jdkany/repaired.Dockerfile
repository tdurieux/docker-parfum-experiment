# Create a Docker image that is ready to run the full Randoop tests.
# It's used primarily for running miscellaneous tests such as the manual,
# Javadoc, and running the Checker Framework.

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
  openjdk-8-jdk \
&& update-java-alternatives --set java-1.8.0-openjdk-amd64 && rm -rf /var/lib/apt/lists/*;

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
# To install html5validator as user rather than as root: pip3 install --user html5validator

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy --no-install-recommends install \
  perl \
  wget && rm -rf /var/lib/apt/lists/*;

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
