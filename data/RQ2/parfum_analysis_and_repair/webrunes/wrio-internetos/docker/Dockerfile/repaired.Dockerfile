FROM ubuntu:15.04
MAINTAINER Michael Bilenko <denso.ffff@gmail.com>
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs mc libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev build-essential g++ git libkrb5-dev && rm -rf /var/lib/apt/lists/*;
RUN npm install -g http-server browserify gulp nodemon mocha && npm cache clean --force;
RUN mkdir -p /srv/www
RUN npm install -g babel@5.6.14 && npm cache clean --force;
RUN npm install -g npm@3 && npm cache clean --force;

