FROM ubuntu:20.04
LABEL maintainer "Chris Ohk <utilforever@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    python3-pip \
    python3-venv \
    python3-setuptools \
    cmake \
    gcc-10 \
    g++-10 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

WORKDIR /app/build
RUN cmake .. -DCMAKE_C_COMPILER=gcc-10 -DCMAKE_CXX_COMPILER=g++-10 && \
    make -j "$(nproc)" && \
    make install && \
    bin/UnitTests

WORKDIR /app/ENV3
RUN cd .. && \
    pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir . && \
    python3 -m pytest ./Tests/PythonTests

WORKDIR /