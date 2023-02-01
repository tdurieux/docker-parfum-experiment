FROM node:lts

WORKDIR /usr/src/app

COPY dist /usr/src/app

RUN yarn install --production && yarn cache clean;

CMD ["node", "bootstrap.js"]
