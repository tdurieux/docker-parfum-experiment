FROM openjdk:8-jdk as baseequella

# Builder for openEQUELLA 2018.2 and prior

# Expects a host volume: 
# -v /host/directory/for/artifacts:/artifacts

# Install needed tools to build openEQUELLA
# Clean up the apt cache afterwards.

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV VERSION_SBT 1.1.1
ENV VERSION_NODEJS 8.x
LABEL supported.openequella.versions="2018.2"

# Install basic tools.

RUN \
  apt-get update \
  && apt-get install --no-install-recommends -y \
    software-properties-common \
    apt-transport-https \
    curl \
    apt-utils \
# Clean up the cache
  && rm -rf /var/lib/apt/lists/*

# Install IcedTea-Web's javaws.jar into the JRE to allow Web Start / Applet builds of openEQUELLA

RUN curl -f -o icedtea-web-1.8.linux.bin.zip https://icedtea.wildebeest.org/download/icedtea-web-binaries/1.8/linux/icedtea-web-1.8.linux.bin.zip
RUN echo "074955c9ca36b9c02df17a71052584b2da6293808db138baa20a6bee41a2dd38  icedtea-web-1.8.linux.bin.zip" > icedtea-web-checksum.verified
RUN sha256sum -c icedtea-web-checksum.verified
RUN unzip icedtea-web-1.8.linux.bin.zip
RUN cp icedtea-web-image/share/icedtea-web/javaws.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext

# Confirm Applet / Web Start abilities

RUN echo "package org.apache.oe; import javax.jnlp.BasicService; import javax.jnlp.ServiceManager; import javax.jnlp.UnavailableServiceException; public class Test {public static void main(String[] args) {System.out.println();}}" > Test.java
RUN javac Test.java

RUN \

  echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 \
# Prep for yarn \
  && curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
# Prep for nodejs
  && curl -f -sL https://deb.nodesource.com/setup_$VERSION_NODEJS -o nodesource_setup.sh \
  && bash nodesource_setup.sh \
# Install the first 3 dev tools for openEQUELLA
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    nodejs \
    sbt=$VERSION_SBT \
    yarn \
  && rm -rf /var/lib/apt/lists/*

# use the /home/equella as your working directory and switch to the equella user.

RUN useradd -ms /bin/bash equella
WORKDIR /home/equella
USER equella

# Clone openEQUELLA, switch to 2018.2

RUN \
  mkdir /home/equella/repo \
  && cd /home/equella/repo \
  && git clone https://github.com/equella/Equella.git \
  && cd /home/equella/repo/Equella \
  && git checkout stable-2018.2 \
  && sbt sbtVersion

# Install psc-package

ENV VERSION_PSC_PACKAGE v0.4.2

RUN curl -f --create-dirs -Lo /home/equella/tools/pscPackage/bundle/linux64.tar.gz https://github.com/purescript/psc-package/releases/download/$VERSION_PSC_PACKAGE/linux64.tar.gz \
  && cd /home/equella/tools/pscPackage \
  && echo "bdf25acc5b4397bd03fd1da024896c5f33af85ce  bundle/linux64.tar.gz" | shasum -c - \
  && cd /home/equella/tools \
  && tar -xvzf pscPackage/bundle/linux64.tar.gz \
  && rm -r /home/equella/tools/pscPackage && rm pscPackage/bundle/linux64.tar.gz
ENV PATH "$PATH:/home/equella/tools/psc-package"

# Copy in helper files

COPY move-installer-to-host.sh ./
COPY move-upgrader-to-host.sh ./
COPY build-installer.sh ./
COPY build-upgrader.sh ./
