FROM node:14-alpine

RUN apk add --no-cache git

RUN git config --global user.email "noone@example.com"
RUN git config --global user.name "No One"

COPY . /app

WORKDIR /app

RUN npm i -g bugsnag-react-native-cli-*.tgz && npm cache clean --force;

ENTRYPOINT ["/bin/sh"]
