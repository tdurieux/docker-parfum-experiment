FROM python:3.9.1-buster

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get dist-upgrade -y

# Install dependencies and required tools
RUN apt-get install --no-install-recommends -y \
    git \
    libsodium-dev \
    python3-nacl && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/WebOfTrust/keripy.git

WORKDIR /keripy

RUN python3 -m pip install --upgrade pip
RUN if [ -f requirements.txt ]; then \
 pip install --no-cache-dir -r requirements.txt; fi
