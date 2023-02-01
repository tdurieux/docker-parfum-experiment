FROM node:lts as builder

WORKDIR /usr/app

COPY . .
RUN yarn && yarn cache clean;
RUN yarn lint && yarn cache clean;
RUN yarn build && yarn cache clean;

WORKDIR /usr/app/docs

RUN yarn && yarn cache clean;
CMD ["yarn", "build"]
