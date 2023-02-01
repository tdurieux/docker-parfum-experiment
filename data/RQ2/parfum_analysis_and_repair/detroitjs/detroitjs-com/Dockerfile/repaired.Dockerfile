FROM node:8-alpine

ADD . /var/www

WORKDIR /var/www

RUN yarn install && yarn cache clean;
RUN yarn build

EXPOSE 9000

CMD ["yarn", "serve"]
