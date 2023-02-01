FROM node:alpine
LABEL maintainer="ptrcnull <github@ptrcnull.me>"

WORKDIR /usr/src/app

COPY package*.json ./

RUN yarn install --ignore-scripts && yarn cache clean;

COPY . .

RUN yarn compile

CMD [ "yarn", "start" ]
