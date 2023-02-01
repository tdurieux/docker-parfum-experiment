FROM node:alpine

RUN mkdir /app

WORKDIR /app

COPY . /app

RUN yarn && yarn cache clean;

EXPOSE 3000

CMD ["yarn", "start"]