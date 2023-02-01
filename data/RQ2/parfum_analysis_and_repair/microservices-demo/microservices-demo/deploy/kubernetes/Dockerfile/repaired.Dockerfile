FROM alpine:3.12.0 AS runtime

RUN apk add --no-cache bash make

WORKDIR /workdir
