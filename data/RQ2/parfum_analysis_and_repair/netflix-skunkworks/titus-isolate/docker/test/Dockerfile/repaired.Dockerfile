FROM ubuntu:18.04

RUN apt update && apt install --no-install-recommends -y \
    build-essential \
    cmake \
    git \
    python3-all \
    python3-dev \
    python3-pip \
    python3-setuptools \
    ssh && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir wheel

COPY prerequirements.txt .
RUN pip3 install --no-cache-dir -r prerequirements.txt

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
