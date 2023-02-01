FROM node:16.14-alpine

WORKDIR /app

COPY . .
RUN yarn install && yarn cache clean;
RUN yarn build && yarn cache clean;

CMD [ "node", "dist/src/main.js"]
