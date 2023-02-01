FROM ubuntu:trusty
MAINTAINER linyows <linyows@gmail.com>

RUN apt-get -qq update && \
    apt-get install -y --no-install-recommends -qq eglibc-source gcc make libcurl4-gnutls-dev libjansson-dev \
                        bzip2 unzip debhelper dh-make devscripts cdbs clang && rm -rf /var/lib/apt/lists/*;

ENV USER root

RUN mkdir /octopass
WORKDIR /octopass
