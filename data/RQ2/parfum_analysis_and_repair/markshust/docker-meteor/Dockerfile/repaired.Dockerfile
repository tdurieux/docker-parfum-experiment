FROM mhart/alpine-node:8.8
MAINTAINER Mark Shust <mark@shust.com>

RUN apk update && apk add --no-cache \
  python \
  make \
  g++
RUN npm i -g yarn@1.2 && npm cache clean --force;

ONBUILD ADD . /opt/app
ONBUILD RUN cd /opt/app/programs/server \
  && yarn

WORKDIR /opt/app

ENV PORT 80
EXPOSE 80

CMD ["node", "main.js"]
