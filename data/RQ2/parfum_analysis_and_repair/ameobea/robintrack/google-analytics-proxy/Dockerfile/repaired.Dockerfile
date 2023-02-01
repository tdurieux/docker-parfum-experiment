FROM node:13.8-alpine3.10

ADD . /app
WORKDIR /app
RUN yarn && yarn cache clean;

CMD ["node", "index.js"]
