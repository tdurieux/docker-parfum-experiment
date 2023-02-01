FROM alpine
RUN apk update
RUN apk add --no-cache stress-ng
