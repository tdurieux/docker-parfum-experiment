FROM node:latest

RUN npm install -g json-server && npm cache clean --force;

WORKDIR /data
VOLUME /data

ADD data/db.json /data/db.json
ENTRYPOINT ["bash", "json-server /data/db.json"]