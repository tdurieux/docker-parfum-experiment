FROM debian:jessie
MAINTAINER kevin.deisz@gmail.com

ENV DEBIAN_FRONTEND noninteractive
ENV USER kddeisz

RUN apt-get update
RUN apt-get install --no-install-recommends -y --fix-missing build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --fix-missing dh-make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --fix-missing autotools-dev flex bison && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --fix-missing pkg-config check && rm -rf /var/lib/apt/lists/*;

WORKDIR /data
CMD dpkg-buildpackage -us -uc && mkdir -p pkg/ && mv ../*.deb pkg/
