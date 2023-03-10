FROM node:14-alpine AS BUILD_IMAGE

WORKDIR /app

RUN apk update && apk add --no-cache git

COPY ./*.json ./yarn.lock ./

RUN yarn install --frozen-lockfile && yarn cache clean;

COPY ./src ./src



RUN yarn build



FROM gcr.io/distroless/nodejs:14-debug
COPY --from=BUILD_IMAGE /app/lib /app/lib
COPY --from=BUILD_IMAGE /app/node_modules /app/node_modules

WORKDIR /app
COPY ./*.js ./default.yaml ./package.json ./tsconfig.json ./yarn.lock ./.env ./

### debug only
COPY --from=BUILD_IMAGE /app/src /app/src
###

USER 1000

CMD ["lib/servers/exporter/exporter.js"]
