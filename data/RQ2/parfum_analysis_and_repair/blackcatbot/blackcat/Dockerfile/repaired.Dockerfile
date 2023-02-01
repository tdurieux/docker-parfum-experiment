FROM node:lts-alpine

RUN apk add --no-cache python3 make gcc g++ git libtool autoconf automake cmake bash && \
  addgroup -S catrunner && \
  adduser -S catrunner -G catrunner

ENV HUSKY=0
ARG IN_DOCKER=1

SHELL [ "/bin/bash", "-c" ]
COPY --chown=catrunner:catrunner . /home/catrunner/
WORKDIR /home/catrunner/

USER catrunner
RUN yarn install && yarn cache clean;

USER root
RUN apk del python3 make gcc g++ git libtool autoconf automake cmake
USER catrunner

ENTRYPOINT ["node", "src/index.js"]