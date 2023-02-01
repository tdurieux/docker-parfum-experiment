FROM ubuntu:20.04

RUN apt-get update
RUN apt-get -y --no-install-recommends install build-essential python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gcc-7 gcc-8 gcc-9 gcc-10 clang-6.0 clang-7 clang-8 \
  clang-9 clang-10 clang-11 && rm -rf /var/lib/apt/lists/*;

