FROM node:lts-alpine

COPY package.json .
COPY yarn.lock .

RUN yarn install && yarn cache clean;

COPY . .

RUN yarn build && yarn cache clean;

CMD ["yarn", "start:docker"]