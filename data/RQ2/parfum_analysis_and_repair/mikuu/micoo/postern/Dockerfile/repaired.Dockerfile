FROM node:10

WORKDIR /usr/src/app

COPY . .
RUN yarn install && yarn cache clean;

EXPOSE 3003

CMD ["yarn", "start"]
