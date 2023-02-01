FROM node:18-alpine

ENV NODE_ENV=PRODUCTION

WORKDIR /app/basemaps
COPY ./basemaps-landing*.tgz /app/basemaps/
COPY ./basemaps-server*.tgz /app/basemaps/

RUN npm install ./basemaps-landing*.tgz && npm cache clean --force;
RUN npm install ./basemaps-server*.tgz && npm cache clean --force;

ENTRYPOINT ["node", "/app/basemaps/node_modules/.bin/basemaps-server"]
EXPOSE 5000