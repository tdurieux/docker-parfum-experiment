FROM node:17-slim as builder

WORKDIR /tmp/build
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY ./ ./
RUN yarn build && yarn cache clean;

FROM nginx:1.23-alpine

COPY --from=builder /tmp/build/out /usr/share/nginx/html/
