FROM ubuntu:trusty
MAINTAINER "Ilkka Seppälä" <ilkka.seppala@gofore.com>

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update && apt-get -qq --no-install-recommends install -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get -qq update && apt-get -qq --no-install-recommends install git curl wget openjdk-8-jre-headless debhelper -y && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates -f
WORKDIR /workspace
