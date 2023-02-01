FROM node:6
RUN npm i -g typescript && npm cache clean --force;
RUN npm i -g tslint && npm cache clean --force;
RUN npm i -g webpack && npm cache clean --force;

# GOPATH
WORKDIR /srv/boil
