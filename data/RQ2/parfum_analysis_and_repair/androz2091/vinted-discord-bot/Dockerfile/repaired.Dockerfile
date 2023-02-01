FROM node:17-alpine3.12

RUN mkdir -p /home/app

COPY ./app /home/app

WORKDIR /home/app

RUN yarn install && yarn cache clean;

RUN yarn build

CMD [ "yarn", "start" ]
