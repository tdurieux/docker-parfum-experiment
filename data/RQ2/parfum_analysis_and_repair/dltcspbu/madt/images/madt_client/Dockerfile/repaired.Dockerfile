FROM python:3-alpine

RUN apk add --no-cache -U gcc \
								musl-dev \
								python3-dev \
								linux-headers \
								zeromq-dev \
								iproute2 \
								iptables && \
    pip3 install --no-cache-dir requests pyzmq

ADD ./lib /etc/madt/madt_client

ENV PYTHONPATH=/etc/madt:$PYTHONPATH
