FROM node:10-alpine as dependencies

WORKDIR /service
COPY package.json ./
RUN yarn && yarn cache clean;

COPY ./src ./src

CMD ["yarn", "start"]