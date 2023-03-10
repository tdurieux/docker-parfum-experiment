FROM arm32v7/node:12-alpine

RUN apk add --no-cache git && mkdir /app && chown nobody:nogroup /app

WORKDIR /app

USER nobody

COPY yarn.lock /app
COPY package.json /app
RUN yarn install && yarn cache clean;

COPY . /app

EXPOSE 3000

CMD yarn start
