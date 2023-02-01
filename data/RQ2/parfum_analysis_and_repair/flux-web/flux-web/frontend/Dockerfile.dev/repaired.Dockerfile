FROM node:alpine as builder

WORKDIR /app

RUN apk add --no-cache python alpine-sdk

COPY package.json ./
COPY yarn.lock ./

RUN yarn

COPY . .

CMD npm run dev