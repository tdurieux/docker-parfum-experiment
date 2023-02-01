# Dockerfile used solely for building sidecar in Linux

FROM ubuntu:14.04

RUN apt-get update -y
RUN apt-get install --no-install-recommends -q -y libzmq3-dev pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y nodejs-legacy npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g node-gyp && npm cache clean --force;

ADD . /srv/sidecar
WORKDIR /srv/sidecar

RUN npm run build
RUN npm install -g electron-packager && npm cache clean --force;
RUN electron-packager ./ SideCar --platform=linux --arch=x64 --version=0.28.3
