FROM node:16-alpine


RUN apk add --no-cache git
# Git is required for husky during build stage

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
ENV PORT 3000

WORKDIR /usr/src/app

COPY package.json /usr/src/app
COPY yarn.lock /usr/src/app

RUN yarn install && yarn cache clean;

COPY . /usr/src/app

RUN yarn build

EXPOSE 3000
CMD [ "yarn", "start" ]
