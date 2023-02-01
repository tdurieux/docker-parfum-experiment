FROM node:16.14.2-alpine as builder
RUN apk add --no-cache make gcc g++ python3

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;

COPY . .
RUN yarn build

# Required as bcrypt has extra dependencies we do not want to include in the
# final image (to reduce image size)
FROM node:16.14.2-alpine as bcrypt_builder
RUN apk add --no-cache make gcc g++ python3
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production && yarn cache clean;


FROM node:16.14.2-alpine as runner
WORKDIR /app

COPY package.json yarn.lock ./
COPY --from=bcrypt_builder /app/node_modules ./node_modules

COPY --from=builder /app/build ./build

ENV port 8080

EXPOSE 8080

CMD ["node", "build/server.js"]

