FROM node:10-alpine

WORKDIR /usr/src/app
COPY package.json yarn.lock ./
COPY . .
RUN yarn && yarn cache clean;
EXPOSE 3000 3306 6379
CMD [ "yarn", "start:dev" ]
