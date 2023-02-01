FROM node:12-alpine

COPY package*.json ./
RUN yarn install && yarn cache clean;
COPY ./ ./

# No need to build, running ts node
CMD yarn run start
