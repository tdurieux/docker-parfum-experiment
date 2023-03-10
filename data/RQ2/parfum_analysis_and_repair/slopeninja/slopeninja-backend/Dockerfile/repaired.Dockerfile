FROM node:8.11.3-alpine as builder

WORKDIR /app

# install all dependencies
COPY package.json .
COPY yarn.lock .
RUN yarn install --frozen-lockfile && yarn cache clean;

COPY . .
RUN yarn build

FROM node:8.11.3-alpine

WORKDIR /app

# install prod dependencies
COPY package.json .
COPY yarn.lock .
RUN yarn install --production --frozen-lockfile && yarn cache clean;

COPY --from=builder /app/build ./build

EXPOSE 8080

CMD [ "yarn", "start" ]
