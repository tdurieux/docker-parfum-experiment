ARG ARCH=
FROM ${ARCH}ubuntu:18.04

WORKDIR /root

RUN \
    apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    build-essential \
    libtool \
    time \
    bc \
    python3 \
    python3-pip \
    wget && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir torch==1.7.1+cpu torchvision==0.8.2+cpu -f https://download.pytorch.org/whl/torch_stable.html
RUN pip3 install --no-cache-dir pillow tqdm

COPY main.py .
COPY assets assets
