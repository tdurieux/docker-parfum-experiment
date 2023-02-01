FROM python:3-alpine

RUN apk update
RUN apk add --no-cache py-pip gmp python3-dev gcc g++ make libffi-dev openssl-dev
RUN pip install --no-cache-dir flask gunicorn requests pycryptodome logzero
ENV LIBRARY_PATH=/lib:/usr/lib

ADD . /app/
WORKDIR /app/

ENV PORT=1024 BIND_ADDR=0.0.0.0

ENTRYPOINT /app/start.sh