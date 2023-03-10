ARG INSTANA_LAYER=icr.io/instana/aws-fargate-nodejs:latest
ARG NODEJS_VERSION=12.16.3

FROM ${INSTANA_LAYER} as instanaLayer

FROM node:${NODEJS_VERSION}-alpine
WORKDIR /usr/src/app

COPY --from=instanaLayer /instana /instana

COPY package*.json ./
COPY . .
RUN apk add --no-cache --virtual .gyp \
        build-base \
        python \
    && npm install --only=production \
    && /instana/setup.sh \
    && apk del .gyp python && npm cache clean --force;

ENV NODE_OPTIONS="--require /instana/node_modules/@instana/aws-fargate"

EXPOSE 4816

ENTRYPOINT [ "npm", "start" ]
