FROM node:8.12.0-alpine as base
WORKDIR /home/node/app
COPY . ./
RUN yarn install && yarn cache clean;
CMD [ "yarn", "start" ]