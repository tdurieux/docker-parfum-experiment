FROM node:14

ENV HOME /Express-Starter

WORKDIR ${HOME}
ADD . $HOME

RUN npm install && npm cache clean --force;

EXPOSE 3000
