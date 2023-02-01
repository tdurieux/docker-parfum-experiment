FROM alpine:3.10.2

RUN apk update
RUN apk add --no-cache \
    gcc \
    g++ \
    linux-headers \
    python3 \
    python3-dev

WORKDIR /works

RUN pip3 install --no-cache-dir --default-timeout=100 virtualenv
RUN virtualenv .venv -p /usr/bin/python3 \
    && . .venv/bin/activate \
    && pip install --no-cache-dir --default-timeout=100 \
        jupyter

ENTRYPOINT [ ". .venv/bin/activate" ]
