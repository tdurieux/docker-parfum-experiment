FROM python:3-alpine as base

WORKDIR /svc

RUN apk update && apk add --no-cache build-base libzmq musl-dev zeromq-dev

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir Cython
RUN pip install --no-cache-dir wheel && pip wheel --wheel-dir=/svc/wheels sqlite_rx


FROM python:3-alpine
RUN apk update && apk add --no-cache libzmq

COPY --from=base /svc /svc
WORKDIR /svc

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --no-index --find-links=/svc/wheels sqlite_rx

