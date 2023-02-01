FROM node:12

COPY ./ /app

WORKDIR /app

RUN yarn install && yarn cache clean;

CMD ["yarn", "start"]

EXPOSE 3000
