FROM alpine:edge

RUN apk update && apk add --no-cache build-base libzmq musl-dev python3 python3-dev zeromq-dev py-pip

RUN pip install --no-cache-dir -U Cython
RUN pip install --no-cache-dir -U sqlite_rx
RUN apk del build-base musl-dev python3-dev zeromq-dev
