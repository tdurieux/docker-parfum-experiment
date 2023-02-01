FROM ubuntu:latest

RUN apt-get update -y && apt-get install --no-install-recommends -y lua5.3 \
    lua-socket \
    lua-sec && rm -rf /var/lib/apt/lists/*;