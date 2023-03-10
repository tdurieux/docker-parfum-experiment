FROM node:12-alpine
RUN apk add --no-cache bash

ENTRYPOINT ["yarn"]
CMD ["watch"]

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile && yarn cache clean && yarn cache clean;

COPY ./__tests__ ./__tests__
COPY ./sql ./sql
COPY ./src  ./src
COPY ./perfTest  ./perfTest
COPY ./tsconfig.json ./
COPY ./jest.config.js ./


RUN yarn prepack && yarn cache clean;
