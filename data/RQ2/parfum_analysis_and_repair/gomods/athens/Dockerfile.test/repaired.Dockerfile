ARG GOLANG_VERSION=1.18
FROM golang:$GOLANG_VERSION

RUN echo $GOLANG_VERSION

RUN mkdir -p /athens/tests

WORKDIR /athens/tests

COPY . .