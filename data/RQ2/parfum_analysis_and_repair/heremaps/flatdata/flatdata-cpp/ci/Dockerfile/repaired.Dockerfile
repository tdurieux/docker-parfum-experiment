# CI image for building with gcc and clang
FROM alpine:latest

RUN apk --no-cache add \
    binutils \
    boost-dev \
    clang \
    cmake \
    doxygen \
    g++ \
    gfortran \
    make \
    musl-dev \
    python3 \
    && pip3 install --no-cache-dir \
    breathe \
    sphinx \
    jinja2 \
    nose \
    pandas \
    pyparsing

