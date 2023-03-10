# BUILDING
# docker build -t stuckless/sagetv-server-java8:latest .

FROM stuckless/sagetv-base:latest

MAINTAINER Sean Stuckless <sean.stuckless@gmail.com>

RUN set -x

RUN \
  echo oracle-java9-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install --no-install-recommends -y oracle-java9-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk9-installer


# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-9-oracle

RUN apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

