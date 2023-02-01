FROM node:14.18.1-alpine3.14

RUN apk add --no-cache bash
RUN apk add --no-cache git

RUN mkdir /HConfig && mkdir /HPlugins && mkdir /Hindenburg
WORKDIR /Hindenburg
COPY . /Hindenburg

EXPOSE 22023

ENV HINDENBURG_PLUGINS /HPlugins
ENV HINDENBURG_CONFIG /HConfig/config.json

RUN yarn
RUN yarn build

ENTRYPOINT ["yarn", "start"]
