FROM node:latest

WORKDIR /donggle-client-development

RUN yarn && yarn cache clean;

ENV NODE_OPTIONS --openssl-legacy-provider

CMD ["yarn", "start"]