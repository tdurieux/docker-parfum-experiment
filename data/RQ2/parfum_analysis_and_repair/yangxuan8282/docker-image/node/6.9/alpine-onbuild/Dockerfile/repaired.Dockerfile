FROM yangxuan8282/rpi-alpine-node:6-alpine
MAINTAINER Yangxuan <yangxuan8282@gmail.com>

RUN apk add --no-cache git bash
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

ONBUILD ARG NODE_ENV
ONBUILD ENV NODE_ENV $NODE_ENV
ONBUILD COPY package.json /usr/src/app/
 \
RUN npm install && npm cache clean --forceONBUILD
ONBUILD COPY . /usr/src/app

CMD [ "npm", "start" ]
