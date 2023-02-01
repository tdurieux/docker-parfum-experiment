FROM nvidia/cuda:8.0-cudnn7-devel

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository -y ppa:certbot/certbot && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libatlas-base-dev \
    libopencv-dev \
    graphviz \
    python-dev \
    openjdk-8-jdk \
    nginx \
    protobuf-compiler \
    libprotoc-dev \
    python-certbot-nginx \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/* \
    && cd /tmp \
    && curl -f -O https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && pip install --no-cache-dir gevent gunicorn

