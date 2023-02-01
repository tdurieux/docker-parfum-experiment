# We need gcc 8 for filesystem support
FROM alpine:3.12

RUN apk add --no-cache -U libtool automake g++ boost-dev boost-static git cmake make readline-dev musl-dev
