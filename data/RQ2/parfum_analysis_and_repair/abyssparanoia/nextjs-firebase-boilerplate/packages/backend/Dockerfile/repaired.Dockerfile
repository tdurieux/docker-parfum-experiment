FROM node:lts-alpine

RUN mkdir -p /app
ADD . /app
WORKDIR /app

RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;


ENV PORT 3001
EXPOSE 3001

ENTRYPOINT ["yarn", "workspace", "@abyssparanoia/backend","start:prod"]