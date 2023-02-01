FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    libx11-6 libgomp1 python3 && rm -rf /var/lib/apt/lists/*;

COPY lib /usr/lib/

COPY bin /usr/bin/

COPY pylib /usr/lib/python3/dist-packages/
