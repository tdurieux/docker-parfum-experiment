FROM ubuntu:14.04

RUN ["apt-get", "update"]
RUN ["apt-get", "-y", "install", "build-essential", "python3"]
RUN ["apt-get", "-y", "install", "gcc", "clang-3.6"]