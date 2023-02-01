FROM node:alpine

WORKDIR /usr/src/app

RUN apk add --no-cache yarn

RUN yarn global add nodemon

COPY package.json yarn.lock ./

RUN yarn install && yarn cache clean;

COPY ./ ./

EXPOSE 8000

CMD ["yarn", "start:local"]
