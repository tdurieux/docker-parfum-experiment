FROM node:16-alpine

WORKDIR /server

COPY package.json yarn.lock ./

RUN yarn install && yarn cache clean;

COPY . .

CMD ["yarn", "run", "start"]
