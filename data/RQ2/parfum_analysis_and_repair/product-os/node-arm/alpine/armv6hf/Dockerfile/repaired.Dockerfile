FROM balenalib/rpi-alpine:3.11

ENV CFLAGS="-D__USE_MISC"

RUN apk add --no-cache --virtual build-deps \
    	nano curl make gcc git g++ python py-pip paxctl libuv-dev \
    	musl-dev openssl-dev zlib-dev paxmark \
    	linux-headers binutils-gold coreutils

# Install AWS CLI
RUN pip install --no-cache-dir awscli

RUN git clone https://github.com/nodejs/node.git

COPY . /
