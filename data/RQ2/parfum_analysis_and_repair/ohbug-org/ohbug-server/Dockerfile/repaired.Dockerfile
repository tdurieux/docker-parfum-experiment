FROM node:14-alpine as dependencies
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --network-timeout 600000 && yarn cache clean;

# ------------------------------------
FROM node:14-alpine as builder
WORKDIR /app
COPY . .
COPY --from=dependencies /app/node_modules ./node_modules
RUN yarn build && yarn cache clean;

# ------------------------------------
FROM node:14-alpine as runner
LABEL maintainer="chenyueban <jasonchan0527@gmail.com>"
WORKDIR /app
ENV NODE_ENV production

COPY package.json yarn.lock ./
RUN yarn install --production --network-timeout 600000 && yarn cache clean;
COPY --from=builder /app/dist/packages  /app/ohbug

# default
ENTRYPOINT [ "node", "./ohbug/dashboard/main.js"]
