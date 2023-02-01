FROM ubuntu:18.04

RUN apt-get update && apt-get --assume-yes -y --no-install-recommends install cmake g++-7 git ninja-build python3 && rm -rf /var/lib/apt/lists/*;

ENV CC=gcc-7
ENV CXX=g++-7

WORKDIR /app
