FROM node:lts-alpine

ENV APP_HOME=/srv \
  TINI_VERSION=v0.19.0

WORKDIR ${APP_HOME}

COPY . ./

RUN set -eux; \
  apk update; \
  yarn install --production && yarn cache clean;

EXPOSE 3000

CMD ["yarn", "start"]