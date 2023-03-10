FROM ubuntu:bionic

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential libxml2-dev python3-dev python3-pip zlib1g-dev python3-requests python3-aiohttp && \
    python3 -m pip install --upgrade pip && \
    pip3 install --no-cache-dir cellxgene && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["cellxgene"]
