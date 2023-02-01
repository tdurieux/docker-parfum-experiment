FROM node:lts-alpine3.15

WORKDIR /frontend
COPY . .
RUN yarn install && yarn cache clean;
EXPOSE 3000
