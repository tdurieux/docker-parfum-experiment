FROM ubuntu:16.04

RUN apt update && apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
COPY Makefile checker.c /tmp/
WORKDIR /tmp
RUN make
