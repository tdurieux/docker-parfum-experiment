FROM node:alpine

ENV NODE_ENV production

ADD dist/website /home/www
WORKDIR /home/www

ENTRYPOINT node .