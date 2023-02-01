FROM alpine:3.7

RUN apk update && \
    apk add --no-cache zip gcc g++ make zlib zlib-dev
# build-base

RUN wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz && \
    tar -xzvf Python-3.6.1.tgz && \
    cd Python-3.6.1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && rm Python-3.6.1.tgz

WORKDIR /opt

# Error like this when running "make install" for python in the Docker image
# https://stackoverflow.com/questions/41146296/missing-socket-after-compile-python-3-6
# but ./python   works


