FROM node:16.2 as builder

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .
RUN yarn build && yarn cache clean;

FROM node:16.2.0-alpine3.13
WORKDIR /app

COPY --from=builder /usr/src/app/build .
COPY --from=builder /usr/src/app/package.json .
COPY --from=builder /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["node", "index.js"]
