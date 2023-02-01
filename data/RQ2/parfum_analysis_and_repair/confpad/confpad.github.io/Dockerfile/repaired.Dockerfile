FROM node:12-slim

WORKDIR /app

# Global packages
RUN yarn global add jest && yarn cache clean;

# Local packages
RUN yarn add glob && yarn cache clean;
RUN yarn add js-yaml && yarn cache clean;
RUN yarn add slugify && yarn cache clean;
