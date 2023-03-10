#
# ---- Base Image ----
FROM node:12.18-alpine AS base

WORKDIR /opt/k2v_bridge

RUN apk --no-cache add \
      bash \
      ca-certificates \
      cyrus-sasl-dev \
      g++ \
      lz4-dev \
      make \
      musl-dev \
      python

RUN apk add --no-cache --virtual \
      .build-deps \
      gcc \
      zlib-dev \
      libc-dev \
      bsd-compat-headers \
      py-setuptools bash

COPY package.json .
COPY package-lock.json .

#
# ---- Install dependencies
RUN npm install && npm cache clean --force;

COPY ./bin/ ./bin
COPY ./app ./app
COPY ./config ./config
COPY ./index.js ./index.js

#
# --- Production Image
FROM node:12.18-alpine

WORKDIR /opt/k2v_bridge

RUN apk --no-cache add \
      bash \
      libsasl \
      lz4-libs \
      tini

COPY --from=base /opt/k2v_bridge /opt/k2v_bridge

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["./bin/entryPoint.sh", "npm", "run", "app"]

HEALTHCHECK --start-period=5s --interval=30s --timeout=5s --retries=3 \
      CMD wget http://localhost:9000/health -q -O - > /dev/null 2>&1