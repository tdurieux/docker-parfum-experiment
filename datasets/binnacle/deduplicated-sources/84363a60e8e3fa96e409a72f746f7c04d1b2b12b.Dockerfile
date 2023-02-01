FROM node:8.10-alpine

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD ./node_modules ./node_modules
ADD ./package.json ./package.json
ADD ./package-lock.json ./package-lock.json
RUN npm prune --production
ADD ./lib ./lib
RUN cd node_modules && \
    rm -rf gitpunch-lib && \
    mv ../lib . && \
    mv lib gitpunch-lib && \
    rm -rf gitpunch-lib/node_modules
