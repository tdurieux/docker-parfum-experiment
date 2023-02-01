FROM ubuntu:16.04

RUN apt update && apt-get install --no-install-recommends -y \
build-essential \
libfuse-dev \
cmake && rm -rf /var/lib/apt/lists/*;

