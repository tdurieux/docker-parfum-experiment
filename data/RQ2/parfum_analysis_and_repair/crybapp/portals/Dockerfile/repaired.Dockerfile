FROM node:lts-buster

WORKDIR /usr/src/app
COPY . .

RUN yarn && yarn global add typescript && yarn cache clean;
RUN yarn build && yarn cache clean;

EXPOSE 1337

CMD yarn start
