FROM ubuntu:trusty
MAINTAINER GoCD Team <go-cd@googlegroups.com>

RUN apt-get update && apt-get -y --no-install-recommends install fakeroot apt-transport-https curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade

