FROM node:16-alpine AS BUILD_IMAGE

WORKDIR /app

RUN apk update && apk add --no-cache git

COPY ./*.json ./yarn.lock ./

RUN yarn install --frozen-lockfile && yarn cache clean;

COPY ./src ./src
COPY ./test ./test

RUN yarn build && yarn cache clean;

FROM gcr.io/distroless/nodejs:16-debug
COPY --from=BUILD_IMAGE /app/lib /app/lib
COPY --from=BUILD_IMAGE /app/src/config/locales /app/lib/config/locales
COPY --from=BUILD_IMAGE /app/node_modules /app/node_modules

WORKDIR /app
COPY ./*.js ./default.yaml ./package.json ./tsconfig.json ./yarn.lock ./.env ./

### debug only
COPY --from=BUILD_IMAGE /app/src /app/src
COPY --from=BUILD_IMAGE /app/test /app/test
COPY ./junit.xml ./
###

USER 1000

ARG BUILDTIME
ARG COMMITHASH
ENV BUILDTIME ${BUILDTIME}
ENV COMMITHASH ${COMMITHASH}

ENTRYPOINT ["/busybox/sleep", "1d"]
