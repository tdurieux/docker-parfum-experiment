FROM ubuntu:16.04
MAINTAINER LightBend <lightbend>

#Install java properly
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update && apt-get -y --no-install-recommends install software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install --no-install-recommends -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN java -version

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install --no-install-recommends -qqy \
    curl \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables && rm -rf /var/lib/apt/lists/*;

# Install Docker from Docker Inc. repositories.
RUN curl -f -sSL https://get.docker.com | sh

# Install the magic wrapper.d
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker

#install mesos - latest
RUN apt-get update -qq && apt-get -y --no-install-recommends install upstart-sysv && rm -rf /var/lib/apt/lists/*;

# for mesos >=1.3
RUN apt-get install --no-install-recommends -y libcurl4-gnutls-dev && apt-get install --no-install-recommends -y dmsetup && rm -rf /var/lib/apt/lists/*;

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]') && \
    CODENAME=$(lsb_release -cs) && \
    MARATHON_VERSION=1.1.1 && \
    echo $CODENAME && \
    echo $DISTRO && \
    echo "deb http://repos.mesosphere.io/${DISTRO} $CODENAME main" | tee /etc/apt/sources.list.d/mesosphere.list && \
    apt-get -yq update && \
    VERSION=$(apt-cache madison mesos | head -1 | awk '{ print $3 }') && \
    apt-get -y --no-install-recommends install mesos=$VERSION && \
    curl -f -O http://downloads.mesosphere.com/marathon/v$MARATHON_VERSION/marathon-$MARATHON_VERSION.tgz && \
    tar xzf marathon-$MARATHON_VERSION.tgz && \
    rm -rf /var/lib/apt/lists/* && rm marathon-$MARATHON_VERSION.tgz
