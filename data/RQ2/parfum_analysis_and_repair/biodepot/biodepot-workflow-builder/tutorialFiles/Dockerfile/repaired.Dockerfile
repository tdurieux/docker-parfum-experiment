#from https://github.com/frol/docker-alpine-python2/blob/master/Dockerfile - the Dockerfile used for Python2 widget
FROM alpine:3.7
RUN apk add --no-cache python && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip install --no-cache-dir --upgrade pip setuptools && \
    rm -r /root/.cache

#added these lines for cutadapt
RUN apk add --no-cache gcc gzip python-dev libc-dev && \
    pip install --no-cache-dir cutadapt && \
    apk del gcc python-dev libc-dev && \
    rm -r /root/.cache
