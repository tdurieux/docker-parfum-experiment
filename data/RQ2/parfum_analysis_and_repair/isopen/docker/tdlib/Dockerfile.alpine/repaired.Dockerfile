FROM alpine:3.7

RUN apk update
RUN apk add --no-cache -U alpine-sdk g++ ccache openssl openssl-dev cmake gperf make git readline-dev

WORKDIR /
COPY . /td

WORKDIR /td
RUN mkdir build
WORKDIR build
RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN cmake --build .
