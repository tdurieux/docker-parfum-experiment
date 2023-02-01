FROM debian:stretch

RUN apt-get update && \
    apt-get -y --no-install-recommends install git \
    procps \
    python-dev \
    python-pip \
    curl \
    vim && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip setuptools

WORKDIR /app
ADD . /app

RUN pip install --no-cache-dir -r /app/requirements-dev.txt


