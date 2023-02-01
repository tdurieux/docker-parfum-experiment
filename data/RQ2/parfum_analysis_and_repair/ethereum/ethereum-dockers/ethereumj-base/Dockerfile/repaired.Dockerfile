FROM ubuntu:14.04.2

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN apt-get install --no-install-recommends -y oracle-java7-installer maven git && rm -rf /var/lib/apt/lists/*;
