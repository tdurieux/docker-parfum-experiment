FROM python:3.6-alpine

WORKDIR /pb
ADD . /build

RUN apk add --no-cache --virtual .build-deps git \
    && pip install --no-cache-dir /build \
    && apk del .build-deps

CMD ["python", "-m", "pb"]
