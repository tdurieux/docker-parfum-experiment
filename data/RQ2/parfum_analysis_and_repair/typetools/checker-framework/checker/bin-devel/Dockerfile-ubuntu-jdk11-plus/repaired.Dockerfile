# Create a Docker image that is ready to run the full Checker Framework tests,
# including building the manual and Javadoc, using JDK 11.

# "ubuntu" is the latest LTS release.  "ubuntu:rolling" is the latest release.
FROM ubuntu
MAINTAINER Michael Ernst <mernst@cs.washington.edu>

## Keep this file in sync with ../../docs/manual/troubleshooting.tex

# According to
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/:
#  * Put "apt-get update" and "apt-get install" and apt cleanup in the same RUN command.
#  * Do not run "apt-get upgrade"; instead get upstream to update.

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy --no-install-recommends install \
  openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy --no-install-recommends install \
  ant \
  cpp \
  git \
  gradle \
  jq \
  libcurl3-gnutls \
  make \
  maven \
  mercurial \
  python3-pip \
  python3-requests \
  unzip \
  wget && rm -rf /var/lib/apt/lists/*;

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy --no-install-recommends install \
  autoconf \
  devscripts \
  dia \
  hevea \
  imagemagick \
  jtreg \
  junit \
  latexmk \
  librsvg2-bin \
  libasound2-dev libcups2-dev libfontconfig1-dev \
  libx11-dev libxext-dev libxrender-dev libxrandr-dev libxtst-dev libxt-dev \
  pdf2svg \
  rsync \
  shellcheck \
  texlive-font-utils \
  texlive-fonts-recommended \
  texlive-latex-base \
  texlive-latex-extra \
  texlive-latex-recommended && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir black flake8 html5validator

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
