FROM node:12

LABEL maintainer="MHacks Team <tech@mhacks.org>"

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV
WORKDIR /usr/src/app

RUN npm install -g nodemon && npm cache clean --force;
RUN npm install mailgun-js && npm cache clean --force;

ADD yarn.lock .
ADD package.json .

RUN yarn install && yarn cache clean;

ADD . .

RUN yarn run build

CMD ["yarn", "start"]
EXPOSE 3000
