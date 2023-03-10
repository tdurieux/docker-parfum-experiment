# MAKIBOT DOCKERFILE 🤖
# made with ❤️ by your friends at makigas

FROM node:16-alpine
RUN mkdir /makibot
WORKDIR /makibot

ARG VERSION_TAG
ENV VERSION_TAG=${VERSION_TAG}

# Server dependencies
RUN apk add --no-cache --update dumb-init

# Add source code
ADD . .

RUN apk add --virtual npm-deps --no-cache --update python3 build-base && \
    npm install && \
    npm run build && \
    npm install --only=production && \
    npm cache clean --force && \
    apk del npm-deps

# Set entrypoint