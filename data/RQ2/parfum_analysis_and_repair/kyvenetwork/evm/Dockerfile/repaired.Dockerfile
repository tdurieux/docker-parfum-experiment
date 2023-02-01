FROM node:current-alpine

COPY package.json .
RUN yarn install && yarn cache clean;
COPY . .
RUN yarn build

ENTRYPOINT [ "yarn", "start" ]
