FROM node:8

WORKDIR /usr/src/app

COPY package*.json ./
COPY ./packages/server/package.json ./packages/server/

RUN npm i -g yarn && npm cache clean --force;
RUN yarn install && yarn cache clean;

COPY ./packages/server ./packages/server

WORKDIR ./packages/server

RUN yarn build

EXPOSE 4000

CMD ["node", "./dist/main.js"]