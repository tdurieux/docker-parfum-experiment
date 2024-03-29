FROM ubuntu:19.04

RUN sed -i -e 's/# deb-src/deb-src/g' /etc/apt/sources.list

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y wget dpkg-dev devscripts debhelper dh-autoreconf gnupg2 gnupg-agent dirmngr nano && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get build-dep -y cairo openjdk-8 libfreetype6

RUN useradd -ms /bin/bash builder

USER builder
WORKDIR /home/builder
