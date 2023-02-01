FROM node:12

WORKDIR /app

COPY . /app

RUN yarn install && yarn cache clean;

CMD ["node", "index.js"]
