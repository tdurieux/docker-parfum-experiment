FROM alpine:3.10.3
RUN apk add --no-cache --virtual .build-deps openssl
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
WORKDIR /app