FROM ubuntu:16.04 as baseequella
#  Only run this image if you accept the Oracle JDK 8 license

# Expects a host volume: 
# -v /host/directory/for/artifacts:/artifacts

# Install needed tools to build openEQUELLA
# Clean up the apt cache afterwards.

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV VERSION_SBT 1.1.1
ENV VERSION_NODEJS 8.x
LABEL supported.openequella.versions="6.6,6.7"

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

# Install Java
RUN \
 echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
  && add-apt-repository -y ppa:webupd8team/java \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    oracle-java8-installer \
  && rm -rf /var/cache/oracle-jdk8-installer && rm -rf /var/lib/apt/lists/*;

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

# Pull down the master branch of openEQUELLA
RUN \
  mkdir /home/equella/repo \
  && cd /home/equella/repo \
  && git clone https://github.com/equella/Equella.git \
  && cd /home/equella/repo/Equella \
# Could add a 'git checkout' for a specific version if sbt 1.1.1 is bumped for later versions.
# Run a arbitrary, no-op task in the Equella/ directory to pull a bunch of the SBT deps. 
# If you are building an older version (such as 6.5), you can skip this command since 
# the old deps will have to be pulled anyways
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

COPY move-installer-to-host.sh ./
COPY move-upgrader-to-host.sh ./
COPY build-installer.sh ./
COPY build-upgrader.sh ./
