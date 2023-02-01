FROM node:lts-alpine
LABEL MAINTAINER likun7981
RUN npm i -g hlink@next && npm cache clean --force;
EXPOSE 9090
ENV DOCKER true
ENTRYPOINT hlink start
