FROM ubuntu:19.04
LABEL maintainer "Chris Ohk <utilforever@gmail.com>"

RUN apt-get update && apt-get install -y \
    build-essential \
    python-dev \
    python-pip \
    python3-dev \
    python3-pip \
    python3-venv \
    python3-setuptools \
    cmake \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

WORKDIR /app/build
RUN cmake .. && \
    make -j "$(nproc)" && \
    make install && \
    bin/UnitTests

WORKDIR /app/ENV3
RUN cd .. && \
    pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir . && \
    python3 -m pytest ./Tests/PythonTests

WORKDIR /