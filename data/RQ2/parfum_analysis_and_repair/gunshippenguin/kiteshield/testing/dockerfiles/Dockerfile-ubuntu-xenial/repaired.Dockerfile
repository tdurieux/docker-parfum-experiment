FROM ubuntu:16.04

RUN ["apt-get", "update"]
RUN ["apt-get", "-y", "install", "build-essential", "python3"]
RUN ["apt-get", "-y", "install", "gcc", "clang-3.5", "clang-4.0", "clang-5.0"]