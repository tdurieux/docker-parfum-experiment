FROM node:10-slim

WORKDIR /app

COPY  . .

RUN yarn install && yarn cache clean;

RUN yarn build

ENV PORT=3000
ENV NODE_ENV=production

CMD [ "yarn", "start"]