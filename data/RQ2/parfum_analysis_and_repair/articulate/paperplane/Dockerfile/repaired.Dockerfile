FROM node:12-stretch-slim

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn install --pure-lockfile && yarn cache clean;

COPY . .

EXPOSE 3000

CMD ["yarn", "start"]