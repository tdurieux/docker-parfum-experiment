FROM node:12-slim

LABEL version="0.0.0-PLACEHOLDER"
LABEL repository="http://github.com/kamilkisiela/graphql-inspector"
LABEL homepage="http://github.com/kamilkisiela/graphql-inspector"
LABEL maintainer="Kamil Kisiela <kamil.kisiela@gmail.com>"

ENV LOG_LEVEL "debug"

RUN apk --no-cache add git
RUN yarn global add @graphql-inspector/cli@0.0.0-PLACEHOLDER graphql && yarn cache clean;

RUN mkdir /app
WORKDIR /app
