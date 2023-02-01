FROM node:latest

ENV NODE_ENV docker

RUN mkdir /app

WORKDIR /app

COPY ./src /app

RUN yarn && yarn cache clean;

RUN yarn run build && yarn cache clean;

EXPOSE 8080

CMD ["yarn", "start"]
