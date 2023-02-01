FROM node:14

RUN mkdir -p clarence
ENV CLAR_ROOT=clarence

WORKDIR clarence

ADD . ./

RUN npm install . && npm cache clean --force;
