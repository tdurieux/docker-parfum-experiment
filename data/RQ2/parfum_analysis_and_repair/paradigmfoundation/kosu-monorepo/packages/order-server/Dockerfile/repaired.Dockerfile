FROM node:lts
WORKDIR /order-server

RUN yarn global add typescript && yarn cache clean;

COPY . .
RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;

CMD yarn start:production