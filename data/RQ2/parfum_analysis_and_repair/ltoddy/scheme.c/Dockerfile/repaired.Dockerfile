FROM ubuntu:18.04

WORKDIR /usr/src/scheme.c

COPY . /usr/src/scheme.c

RUN apt-get update && \
    apt-get install -y --no-install-recommends cmake && \
    cmake . && make && rm -rf /var/lib/apt/lists/*;

ENV PATH=/usr/src/scheme.c/bin:${PATH}
