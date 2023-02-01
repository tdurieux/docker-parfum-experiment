FROM ubuntu:trusty
MAINTAINER GoCD Team <go-cd@googlegroups.com>

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y --no-install-recommends install git software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:ubuntu-lxc/lxd-stable
RUN apt-get update
RUN apt-get -y --no-install-recommends install golang && rm -rf /var/lib/apt/lists/*;

ADD gocd-golang-agent gocd-golang-agent
