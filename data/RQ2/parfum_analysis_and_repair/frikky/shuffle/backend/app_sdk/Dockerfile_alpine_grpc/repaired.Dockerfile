FROM python:3.10.0-alpine as base

FROM base as builder
RUN apk --no-cache add --update \
        alpine-sdk \
        build-base  \
        g++ \
        gcc \
        libffi \
        libffi-dev \
        libstdc++ \
        linux-headers \
        musl-dev \
        openssl-dev \
        tzdata \
        coreutils

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --prefix="/install" --no-cache-dir grpcio grpcio-tools && \
    apk del --purge \
    g++ \
    gcc \
    musl-dev \
    libffi-dev \
    libstdc++ \
    build-base \
    linux-headers

RUN mkdir -p /install
WORKDIR /install

FROM base

#--no-cache
RUN apk update && apk add --no-cache --update tzdata libmagic alpine-sdk libffi libffi-dev musl-dev openssl-dev coreutils

COPY --from=builder /install /usr/local
COPY requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -r /requirements.txt

COPY __init__.py /app/walkoff_app_sdk/__init__.py
COPY app_base.py /app/walkoff_app_sdk/app_base.py
