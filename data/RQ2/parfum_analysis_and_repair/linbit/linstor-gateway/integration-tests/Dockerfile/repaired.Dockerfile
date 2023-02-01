FROM alpine

RUN apk update && \
    apk add --no-cache openssh bash python3 py3-pip

RUN pip install --no-cache-dir lbpytest

COPY entry.sh gatewaytest.py /
COPY tests /tests

WORKDIR /

ENTRYPOINT /entry.sh
