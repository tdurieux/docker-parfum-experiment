FROM ubuntu:20.04

COPY requirements.txt /tmp/

RUN apt update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y \
    python3 \
    python3-pip \
    cmake \
    python3-opencv && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -r /tmp/requirements.txt
