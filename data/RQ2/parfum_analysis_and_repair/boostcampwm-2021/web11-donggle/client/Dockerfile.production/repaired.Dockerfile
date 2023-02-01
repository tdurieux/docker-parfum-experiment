FROM node:latest

WORKDIR /client-react

COPY ./package.json .
RUN yarn && yarn cache clean;

COPY . .

ENV NODE_OPTIONS --openssl-legacy-provider

ENTRYPOINT ["yarn", "build"]