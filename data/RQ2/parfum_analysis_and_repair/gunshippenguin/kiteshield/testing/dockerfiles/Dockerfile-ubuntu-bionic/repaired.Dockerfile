FROM ubuntu:18.04

RUN apt-get update
RUN apt-get -y --no-install-recommends install build-essential python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gcc-5 gcc-6 gcc-7 gcc-8 clang-4.0 clang-5.0 clang-6.0 \
  clang-7 clang-8 clang-9 clang-10 && rm -rf /var/lib/apt/lists/*;

