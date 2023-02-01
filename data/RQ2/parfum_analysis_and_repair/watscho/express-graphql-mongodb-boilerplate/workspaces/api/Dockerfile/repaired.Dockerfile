FROM node:alpine

WORKDIR /usr/src/app

RUN apk add --no-cache yarn

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile && yarn cache clean;

COPY ./ ./

EXPOSE 8000

CMD ["yarn", "start"]
