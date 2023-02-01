FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl python3-pip python3-wheel python3-dev libffi-dev libssl-dev \
    && pip3 install --no-cache-dir -U pip setuptools \
    && pip install --no-cache-dir flask gunicorn[gevent] requests && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip && \
	pip3 --no-cache-dir install mitmproxy

WORKDIR /app
COPY app/ .
RUN chmod -x run.sh
CMD /bin/bash run.sh
