FROM node:16

WORKDIR /donggle-server-development

RUN yarn && yarn cache clean;

CMD ["yarn", "dev"]