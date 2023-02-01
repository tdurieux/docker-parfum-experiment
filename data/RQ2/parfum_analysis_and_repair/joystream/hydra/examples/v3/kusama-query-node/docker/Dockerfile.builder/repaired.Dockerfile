FROM node:12-alpine

RUN mkdir -p /home/hydra-builder && chown -R node:node /home/hydra-builder

WORKDIR /home/hydra-builder

COPY ./mappings ./mappings
COPY ./*.yml ./
COPY ./*.json ./
COPY ./*.graphql ./
COPY ./.env ./

RUN yarn && yarn cache clean;
RUN yarn codegen && yarn cache clean;
RUN yarn typegen && yarn cache clean;
RUN yarn workspace sample-mappings install
RUN yarn mappings:build && yarn cache clean;

RUN yarn workspace query-node install
RUN yarn workspace query-node compile && yarn cache clean;
