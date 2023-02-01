# Create a Docker image that is ready to run the full Checker Framework tests,
# including building the manual and Javadoc, using JDK 17.

# "ubuntu" is the latest LTS release.  "ubuntu:rolling" is the latest release.
FROM ubuntu
MAINTAINER Michael Ernst <mernst@cs.washington.edu>

## Keep this file in sync with ../../docs/manual/troubleshooting.tex

# According to
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/:
#  * Put "apt-get update" and "apt-get install" and apt cleanup in the same RUN command.
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
  oracle-java17-installer --install-recommends && rm -rf /var/lib/apt/lists/*;

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
&& wget https://mirrors.sonic.net/apache/maven/maven-3/3.8.3/binaries/apache-maven-3.8.3-bin.tar.gz \
&& tar xzvf apache-maven-3.8.3-bin.tar.gz && rm apache-maven-3.8.3-bin.tar.gz
ENV PATH="/apache-maven-3.8.3/bin:$PATH"

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy --no-install-recommends install \
  autoconf \
  devscripts \
  dia \
  hevea \
  imagemagick \
  junit \
  jtreg \
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
