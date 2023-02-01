FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y \
    linux-tools-common \
    linux-tools-generic \
    linux-tools-`uname -r` && rm -rf /var/lib/apt/lists/*;

