FROM node:lts-buster

WORKDIR /usr/src/app
COPY . .

RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;

EXPOSE 4000

CMD yarn start
