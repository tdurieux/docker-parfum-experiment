FROM node:current-alpine

WORKDIR /code

COPY package.json yarn.lock ./

RUN yarn --pure-filelock --production

COPY . .

RUN yarn build

CMD ["node", "dist/index.js"]
