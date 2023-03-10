FROM node:8.12-slim

ENV DIR /opt/admin-api-server
RUN mkdir -p ${DIR}/

WORKDIR $DIR

RUN npm install -g nodemon && npm cache clean --force;

ENTRYPOINT nodemon
