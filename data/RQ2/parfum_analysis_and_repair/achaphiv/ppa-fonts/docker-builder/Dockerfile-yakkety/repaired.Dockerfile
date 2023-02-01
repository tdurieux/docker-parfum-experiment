FROM ubuntu:16.10

RUN sed -i -e 's/# deb-src/deb-src/g' /etc/apt/sources.list

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y wget dpkg-dev devscripts debhelper dh-autoreconf gnupg2 gnupg-agent dirmngr && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash builder

USER builder
WORKDIR /home/builder
