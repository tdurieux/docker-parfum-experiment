FROM ubuntu:latest

RUN apt-get update -y && apt-get install --no-install-recommends -y nasm \
    binutils && rm -rf /var/lib/apt/lists/*;