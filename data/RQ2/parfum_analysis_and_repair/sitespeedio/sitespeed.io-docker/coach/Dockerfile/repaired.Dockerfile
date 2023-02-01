FROM sitespeedio/browsers:firefox-45.0-chrome-49.0

MAINTAINER Peter Hedenskog <peter@soulgalore.com>

RUN \
 apt-get update && \
 apt-get install --no-install-recommends -y curl && \
 curl -f --silent --location https://deb.nodesource.com/setup_4.x | bash - && \
apt-get install -y \
nodejs \
build-essential --no-install-recommends && \
npm set progress=false && \
npm install -g webcoach && npm cache clean --force && \
apt-get purge -y curl git build-essential && \
apt-get clean autoclean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./scripts/ /home/root/scripts

VOLUME /coach

WORKDIR /coach
