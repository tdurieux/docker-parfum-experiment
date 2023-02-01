# Builder image
FROM alpine:3.9 AS builder

RUN apk add --no-cache alpine-sdk bash go nodejs npm

WORKDIR /usr/src/app

COPY . .
RUN make

# Final image