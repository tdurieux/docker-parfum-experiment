FROM bosh/golang-release

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    gcc \
    git \
    jq \
    python3-pip \
    python3-setuptools \
    wget \
    zip \
  && pip3 install --no-cache-dir awscli \
  && apt-get autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
