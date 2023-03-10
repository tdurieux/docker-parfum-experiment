FROM node:16-alpine@sha256:004dbac84fed48e20f9888a23e32fa7cf83c2995e174a78d41d9a9dd1e051a20

RUN apk update && apk add --no-cache g++ make python3

RUN mkdir -p /app
WORKDIR /app

COPY ethereum/package.json ethereum/package-lock.json ./ethereum/
RUN --mount=type=cache,uid=1000,gid=1000,target=/home/node/.npm \
    npm ci --prefix ethereum
COPY ethereum ./ethereum

COPY sdk/js/package.json sdk/js/package-lock.json  ./sdk/js/
RUN --mount=type=cache,uid=1000,gid=1000,target=/home/node/.npm \
    npm ci --prefix sdk/js
COPY sdk/js ./sdk/js
RUN npm run build --prefix sdk/js

COPY spydk/js/package.json spydk/js/package-lock.json ./spydk/js/
RUN --mount=type=cache,uid=1000,gid=1000,target=/home/node/.npm \
    npm ci --prefix spydk/js
COPY spydk/js ./spydk/js
RUN npm run build --prefix spydk/js

COPY bridge_ui/package.json bridge_ui/package-lock.json ./bridge_ui/
RUN --mount=type=cache,uid=1000,gid=1000,target=/home/node/.npm \
    npm ci --prefix bridge_ui
COPY bridge_ui ./bridge_ui

COPY testing ./testing

WORKDIR /app/testing
