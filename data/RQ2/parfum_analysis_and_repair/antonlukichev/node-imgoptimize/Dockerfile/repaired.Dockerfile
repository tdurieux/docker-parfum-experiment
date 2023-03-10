FROM node:alpine
# FROM node:carbon
ENV \
    TERM="xterm-256color"\
    PLATFORM="linuxmusl-x64"\
    NODE_ENV="production"

LABEL maintainer="anton@lukichev.pro"

RUN npm install -g nodemon yarn && npm cache clean --force;

WORKDIR /app

COPY package.json .

RUN yarn install && yarn cache clean;
ENV PATH /app/node_modules/.bin:$PATH

COPY . .

CMD [ "nodemon", "app.js" ]
