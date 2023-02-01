FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get -y --no-install-recommends install llvm git wget cmake libc++-dev libc++abi-dev clang libtool lcov libssl-dev libsrtp2-dev libmicrohttpd-dev libopus-dev zip && rm -rf /var/lib/apt/lists/*;
