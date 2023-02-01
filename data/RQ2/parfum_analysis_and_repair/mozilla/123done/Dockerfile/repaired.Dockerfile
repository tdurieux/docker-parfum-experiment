FROM node:10-alpine

# as root
RUN apk update
RUN apk add --no-cache g++ git
RUN npm install -g bower && npm cache clean --force;

RUN addgroup -g 10001 app && adduser -D -G app -h /app -u 10001 app
WORKDIR /app
USER app

# as app
COPY package.json package.json
COPY bower.json bower.json
COPY .bowerrc .bowerrc
RUN npm install && npm cache clean --force;
RUN /bin/rm -rf .npm

COPY . /app

USER root
RUN apk del -r g++ git

CMD node ./server.js


