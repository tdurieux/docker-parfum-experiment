FROM ubuntu:18.04

RUN apt update && apt install --no-install-recommends -y \
     python3 \
     python3-pip \
     python3-setuptools \
     python3-nacl && rm -rf /var/lib/apt/lists/*;

# pypi based packages
RUN pip3 install --no-cache-dir -U \
    pip \
    setuptools \
    virtualenv