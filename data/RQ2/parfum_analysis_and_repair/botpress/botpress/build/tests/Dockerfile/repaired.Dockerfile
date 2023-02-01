FROM node:12.18.1-alpine

ADD . /code
WORKDIR /code

RUN yarn --frozen-lockfile && yarn cache clean;

RUN ( cd ./modules/nlu && yarn --frozen-lockfile) && yarn cache clean;

CMD ["yarn", "test"]
