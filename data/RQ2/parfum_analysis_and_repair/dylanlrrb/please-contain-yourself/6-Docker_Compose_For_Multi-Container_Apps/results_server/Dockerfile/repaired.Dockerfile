FROM node:8.10-alpine

RUN mkdir -p /src/app

WORKDIR /src/app

COPY . /src/app

RUN yarn install && yarn cache clean;

EXPOSE 3000

CMD [ "npm", "start" ]