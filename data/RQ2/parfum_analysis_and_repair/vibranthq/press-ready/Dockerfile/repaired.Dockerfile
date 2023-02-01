FROM node:14-alpine as base

LABEL maintainer="Yasuaki Uechi"
LABEL license="Apache-2.0"

RUN apk add --no-cache ghostscript poppler-utils

WORKDIR /app
COPY assets/* /app/assets/
COPY package.json yarn.lock /app/

# build press-ready
FROM base as build
RUN yarn install --frozen-lockfile && yarn cache clean;
COPY tsconfig.json .
COPY src/ src/
RUN yarn build && yarn cache clean;

# runtime
FROM base as runtime
COPY --from=build /app/lib/ lib/
RUN yarn install --frozen-lockfile --production && yarn cache clean;

WORKDIR /workdir
ENTRYPOINT [ "/app/lib/cli.js" ]