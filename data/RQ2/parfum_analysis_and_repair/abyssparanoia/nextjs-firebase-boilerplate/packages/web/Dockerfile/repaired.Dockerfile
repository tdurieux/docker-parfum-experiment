FROM node:lts-alpine

RUN mkdir -p /app
ADD . /app
WORKDIR /app

RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;


ENV PORT 3000
EXPOSE 3000

ENTRYPOINT ["yarn", "workspace", "@abyssparanoia/web","start:prod"]