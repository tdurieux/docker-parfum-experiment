FROM alpine:3.15

RUN apk update
RUN apk add --no-cache git curl
RUN apk add --no-cache glab
