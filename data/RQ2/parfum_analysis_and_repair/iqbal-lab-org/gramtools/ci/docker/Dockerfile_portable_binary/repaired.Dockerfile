FROM alpine:3.15

COPY . /gramtools
WORKDIR /gramtools

ARG DEBIAN_FRONTEND=noninteractive
RUN apk update && apk add --no-cache binutils cmake make libgcc musl-dev gcc g++ autoconf automake zlib-dev
RUN apk add --no-cache bash git py3-pip wget

RUN pip install --no-cache-dir conan
RUN chmod +x ./build.sh && ./build.sh
