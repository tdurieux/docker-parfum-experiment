FROM node:15

WORKDIR /usr/src/app

COPY . .
RUN yarn install && yarn cache clean;

EXPOSE 3001

CMD ["yarn", "start"]
