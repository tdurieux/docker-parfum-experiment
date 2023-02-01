FROM ubuntu:focal

RUN : \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        software-properties-common \
    && add-apt-repository ppa:deadsnakes \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        curl \
        python3.10 \
        python3.10-distutils \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN : \
    && curl -f --location https://bootstrap.pypa.io/get-pip.py | python3.10 -
