FROM node:14-alpine

WORKDIR /plataforma-sabia/api

COPY ./packages/api/package*.json /plataforma-sabia/api/

RUN npm install --only=production && npm cache clean --force;

COPY ./packages/api/ /plataforma-sabia/api/
COPY ./packages/api/docker/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]