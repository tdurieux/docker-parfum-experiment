FROM python:3.6-slim

RUN mkdir -p /ctf

WORKDIR /ctf

RUN apt-get update && apt-get install --no-install-recommends -y procps iproute2 clang libc6-dev-i386 llvm && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pycrypto

COPY . .

ENTRYPOINT ./entrypoint.sh
