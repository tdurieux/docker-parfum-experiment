FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y gcc libc6-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*;

COPY . /usr/src/

WORKDIR /usr/src/

RUN gcc -g -Wall -static nnp-test.c -o /usr/bin/nnp-test

RUN chmod +s /usr/bin/nnp-test
