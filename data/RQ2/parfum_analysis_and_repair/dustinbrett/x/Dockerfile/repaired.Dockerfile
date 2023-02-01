FROM node:lts-alpine

RUN apk add --no-cache git

WORKDIR daedalOS
COPY . .

RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;

CMD yarn start
