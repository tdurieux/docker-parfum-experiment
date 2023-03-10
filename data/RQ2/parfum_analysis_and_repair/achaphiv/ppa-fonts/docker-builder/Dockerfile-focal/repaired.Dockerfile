FROM ubuntu:20.04

RUN sed -i -e 's/# deb-src/deb-src/g' /etc/apt/sources.list

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y wget dpkg-dev devscripts debhelper dh-autoreconf gnupg2 gnupg-agent dirmngr nano && rm -rf /var/lib/apt/lists/*;
RUN apt-get build-dep -y cairo openjdk-8 libfreetype6

RUN useradd -ms /bin/bash builder

USER builder
WORKDIR /home/builder
