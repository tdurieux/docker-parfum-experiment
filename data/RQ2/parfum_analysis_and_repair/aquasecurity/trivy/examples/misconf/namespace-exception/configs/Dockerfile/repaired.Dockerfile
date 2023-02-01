FROM alpine:3.11

RUN apk add --no-cache bash
ADD dummy.txt .
