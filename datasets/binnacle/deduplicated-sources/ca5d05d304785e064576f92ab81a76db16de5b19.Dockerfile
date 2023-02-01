#from https://github.com/frol/docker-alpine-python2/blob/master/Dockerfile
FROM alpine:3.7
RUN apk add --no-cache python && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip install --upgrade pip setuptools && \
    rm -r /root/.cache
