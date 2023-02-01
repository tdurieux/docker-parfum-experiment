# $BOONTADATA_DOCKER_REGISTRY/boontadata/devjvm
#
# VERSION   0.1

#FROM openjdk:8
FROM ubuntu:16.04

RUN apt update && \
  apt -y upgrade && \
  apt install --no-install-recommends -y vim && \
  apt install --no-install-recommends -y software-properties-common && \
  add-apt-repository -y ppa:openjdk-r/ppa && \
  apt update && \
  apt install --no-install-recommends -y openjdk-8-jdk && \
  apt install --no-install-recommends -y maven && \
  apt install --no-install-recommends -y scala && \
  apt install --no-install-recommends -y curl && \
  apt install --no-install-recommends -y apt-transport-https && \
  echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
  apt update && \
  apt install --no-install-recommends -y sbt && \
  export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/dev

ENTRYPOINT ["init"]
