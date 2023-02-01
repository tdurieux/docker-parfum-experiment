FROM node:12.7

WORKDIR /usr/src/service

COPY service/package.json .

RUN yarn install && yarn cache clean;

COPY service/ .

EXPOSE 5000

CMD ["yarn", "start"]