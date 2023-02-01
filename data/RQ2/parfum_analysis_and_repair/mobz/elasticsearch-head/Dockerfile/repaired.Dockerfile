FROM node
MAINTAINER Niko Bellic <niko.bellic@kakaocorp.com>

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN npm install -g grunt && npm cache clean --force;

COPY package.json /usr/src/app/package.json
RUN npm install && npm cache clean --force;

COPY . /usr/src/app

EXPOSE 9100

CMD grunt server
