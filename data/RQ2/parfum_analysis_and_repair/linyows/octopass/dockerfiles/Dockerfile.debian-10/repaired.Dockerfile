FROM debian:buster
MAINTAINER linyows <linyows@gmail.com>

RUN apt-get -qq update && \
    apt-get install -y --no-install-recommends -qq glibc-source gcc make libcurl4-gnutls-dev libjansson-dev \
                        bzip2 unzip debhelper dh-make devscripts cdbs clang apt-utils && rm -rf /var/lib/apt/lists/*;

ENV USER root

RUN mkdir /octopass
WORKDIR /octopass
