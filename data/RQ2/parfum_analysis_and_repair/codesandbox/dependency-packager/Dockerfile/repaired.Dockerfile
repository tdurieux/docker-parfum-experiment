FROM node:current-alpine

RUN apk add --no-cache git

WORKDIR /app
COPY package.json .
COPY yarn.lock .

RUN yarn install && yarn cache clean;

ADD . .

RUN yarn build

ENV PORT=3000
EXPOSE 3000

CMD node dist/packager
