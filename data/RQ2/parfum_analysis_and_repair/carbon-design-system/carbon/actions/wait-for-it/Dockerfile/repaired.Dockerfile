FROM node:slim

WORKDIR /usr/src/action
COPY . .
RUN yarn install --production && yarn cache clean;
ENTRYPOINT ["node", "/usr/src/action/src/index.js"]

