FROM node:0.8.28
MAINTAINER Outsider <outsideris@gmail.com>

COPY ./src/ /src
COPY ./.tokens/github.json /src/.tokens/
RUN mkdir /src/archive

RUN npm install -g coffee-script && npm cache clean --force;
RUN npm install -g bower && npm cache clean --force;

RUN cd /src; npm install; npm cache clean --force; bower install --allow-root

ENV MONGODB_HOST hostip
ENV MONGODB_PORT 23002

EXPOSE  8020

CMD ["coffee", "/src/server.coffee"]
