FROM --platform=${BUILDPLATFORM} python:alpine AS pybase
RUN apk add --no-cache \
        ca-certificates \
    && true
RUN pip install --no-cache-dir \
    flake8 \
    pytest \
    pytest-cov \
    && true
WORKDIR /src
