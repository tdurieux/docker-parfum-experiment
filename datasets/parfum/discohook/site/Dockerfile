FROM node:16-alpine AS builder

RUN apk add --no-cache libc6-compat

WORKDIR /app
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn
COPY patches ./patches

RUN yarn install --immutable

COPY . .

ARG BUILD_ID
RUN BUILD_ID=${BUILD_ID} yarn build

FROM node:16-alpine

WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/build ./build
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./

ENV NODE_ENV=production \
    NODE_OPTIONS=--max-http-header-size=81920

USER node

EXPOSE 3000

ENTRYPOINT [ "node_modules/.bin/next" ]
CMD [ "start" ]
