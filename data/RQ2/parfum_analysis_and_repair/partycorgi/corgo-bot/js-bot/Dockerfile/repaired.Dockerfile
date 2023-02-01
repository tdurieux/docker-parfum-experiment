FROM node:14.3.0-alpine3.11
LABEL corgo.language="js"
COPY . /opt/bot
WORKDIR /opt/bot
RUN yarn && yarn cache clean;
ENTRYPOINT node index.js