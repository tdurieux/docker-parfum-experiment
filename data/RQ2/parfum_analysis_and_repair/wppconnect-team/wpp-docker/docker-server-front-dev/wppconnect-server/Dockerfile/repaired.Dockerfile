FROM node:14.17-alpine3.13

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

WORKDIR /home/node/app
COPY ./app .

RUN apk add --no-cache chromium && \
    yarn install && yarn cache clean;

EXPOSE 21465
