FROM debian:jessie
MAINTAINER slush@satoshilabs.com

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV TERM linux

RUN apt-get update && \
    apt-get upgrade -qy && \
    apt-get install --no-install-recommends -qy apt-transport-https curl git && \
    echo 'deb https://deb.nodesource.com/node_4.x jessie main' | tee /etc/apt/sources.list.d/nodesource.list && \
    curl -f -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && \
    apt-get -qy --no-install-recommends install nodejs python make build-essential devscripts dh-systemd && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;
ADD bitcore-testnet/ /root/bitcore-testnet
RUN ( cd /root/bitcore-testnet && debuild -uc -us )

