# Create a Docker image that is ready to run the main Randoop tests,
# using JDK 17.

# "ubuntu" is the latest LTS release.  "ubuntu:rolling" is the latest release.
FROM ubuntu
MAINTAINER Michael Ernst <mernst@cs.washington.edu>

# According to
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/:
#  * Put "apt-get update" and "apt-get install" in the same RUN command.
#  * Do not run "apt-get upgrade"; instead get upstream to update.

# Instructions for installing Java 17 on Ubuntu:
# https://www.linuxuprising.com/2021/09/how-to-install-oracle-java-17-lts-on.html
RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy --no-install-recommends install software-properties-common \
&& add-apt-repository ppa:linuxuprising/java && rm -rf /var/lib/apt/lists/*;

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& echo oracle-java17-installer shared/accepted-oracle-license-v1-3 select true | /usr/bin/debconf-set-selections \
&& echo oracle-java17-installer shared/accepted-oracle-licence-v1-3 boolean true | /usr/bin/debconf-set-selections \
&& apt-get -qqy --no-install-recommends install \
  oracle-java17-installer --install-recommends \
&& apt-get -qqy --no-install-recommends install \
  x11-utils && rm -rf /var/lib/apt/lists/*;

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
