FROM python:3.7-slim
RUN apt-get update && apt-get -y --no-install-recommends install \
    curl \
    wget \
    git \
    sudo \
    zip \
    unzip \
    libssl-dev \
    libncurses5-dev \
    libsqlite3-dev \
    libreadline-dev \
    zlib1g-dev \
    xz-utils \
    gcc \
    make \
    build-essential && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py; \
    python3 get-pip.py; \
    python3 -m pip install --upgrade pip setuptools wheel paho-mqtt cython
