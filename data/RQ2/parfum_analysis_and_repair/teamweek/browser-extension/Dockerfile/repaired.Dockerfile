FROM ubuntu:18.04

RUN apt update -y && apt install --no-install-recommends git make zip wget xz-utils -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp

RUN wget -q --no-check-certificate https://nodejs.org/dist/v8.11.2/node-v8.11.2-linux-x64.tar.xz
RUN tar xf /tmp/node-v8.11.2-linux-x64.tar.xz && rm /tmp/node-v8.11.2-linux-x64.tar.xz
RUN ln -sf /tmp/node-v8.11.2-linux-x64/bin/* /usr/bin && node --version

WORKDIR /opt/button

ADD package.json package.json
RUN npm install --unsafe-perm && npm cache clean --force;

ADD app app
ADD bin bin
ADD src src
ADD Gulpfile.js Gulpfile.js

RUN npm run source && npm run release
