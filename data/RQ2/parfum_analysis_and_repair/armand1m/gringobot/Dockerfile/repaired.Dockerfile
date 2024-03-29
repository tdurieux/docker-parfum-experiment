FROM node:16-alpine AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .
RUN yarn build && yarn cache clean;

FROM node:16-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/build ./build
COPY --from=builder /app/locales ./locales

ENTRYPOINT ["node"]
CMD ["/app/build/index.js"]
