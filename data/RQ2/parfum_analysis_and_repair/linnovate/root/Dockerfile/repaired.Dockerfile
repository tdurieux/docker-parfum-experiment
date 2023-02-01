FROM node:10-alpine

RUN apk update \
  && apk add --no-cache git

RUN npm install -g bower gulp && npm cache clean --force;
USER node:node

COPY --chown=node:node . /usr/src/app

WORKDIR /usr/src/app

ARG ROOT_LANG
RUN npm install \
  && npm run production \
  && npm prune --production && npm cache clean --force;

EXPOSE 3000

CMD ["node", "server"]
