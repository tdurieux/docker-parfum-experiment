FROM ubuntu:16.04
MAINTAINER Sergey Matyukevich <s-matyukevich@gmail.com>
RUN apt-get update && apt-get install --no-install-recommends -y gcc-aarch64-linux-gnu build-essential && rm -rf /var/lib/apt/lists/*;
