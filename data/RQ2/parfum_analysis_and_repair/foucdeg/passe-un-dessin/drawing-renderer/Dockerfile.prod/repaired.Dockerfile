FROM node:alpine

COPY ./package.json /app/package.json
COPY ./yarn.lock /app/yarn.lock
WORKDIR /app

RUN yarn install --production --frozen-lockfile && yarn cache clean;

COPY . /app

CMD ["yarn", "start"]
