FROM node:current-alpine

WORKDIR /code

COPY package.json yarn.lock ./

RUN yarn --pure-filelock --production && yarn cache clean;

COPY . .

RUN yarn build && yarn cache clean;

CMD ["node", "dist/index.js"]
