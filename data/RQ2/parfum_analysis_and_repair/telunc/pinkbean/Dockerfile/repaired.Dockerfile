FROM node:8.0.0-alpine
RUN apk update && apk upgrade && apk add --no-cache git python alpine-sdk
RUN mkdir -p usr/src
WORKDIR /usr/src/
RUN mkdir pinkbean
WORKDIR /usr/src/pinkbean
COPY package.json /usr/src/pinkbean
RUN npm install --production && npm cache clean --force;
COPY . /usr/src/pinkbean
WORKDIR src/
ENTRYPOINT [ "npm", "run","production" ]