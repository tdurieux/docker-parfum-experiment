FROM python:3.8.9-slim

RUN apt-get update && \
    apt-get -y --no-install-recommends install git findutils build-essential unzip wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . .

RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir --require-hashes -r requirements.txt --no-deps --disable-pip-version-check && \
    pip3 cache purge
