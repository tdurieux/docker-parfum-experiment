FROM node:15.12.0-alpine3.10

WORKDIR /usr/src/app

COPY package.json .

RUN apk update && \
    apk upgrade && \
    npm install -g -s --no-progress npm && \
    npm i --only=production && npm cache clean --force;

ADD . /usr/src/app

CMD ["npm", "start"]