FROM node:10-alpine AS BUILDER
WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean && yarn cache clean;
COPY . .
RUN yarn build && yarn cache clean;

FROM node:10-alpine

ENV NODE_ENV=production

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean && yarn cache clean;
COPY --from=BUILDER /app/build ./build
COPY config ./config
RUN yarn install && yarn cache clean && ls config && yarn cache clean;
# To ensure build success when .env is not exist.
COPY .env* ./

CMD ["node", "build/bootstrap"]
