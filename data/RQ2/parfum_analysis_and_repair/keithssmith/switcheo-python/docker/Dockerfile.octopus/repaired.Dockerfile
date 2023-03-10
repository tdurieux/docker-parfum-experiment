FROM jfloff/alpine-python:3.6-slim AS build
RUN apk add --no-cache --update graphviz && \  #python3-dev gcc musl-dev libffi-dev openssl-dev && \
    echo "manylinux1_compatible = True" >> /usr/lib/python3.6/_manylinux.py && \
    python -m pip install --upgrade pip octopus && \
    rm -rf /var/cache/apk/*