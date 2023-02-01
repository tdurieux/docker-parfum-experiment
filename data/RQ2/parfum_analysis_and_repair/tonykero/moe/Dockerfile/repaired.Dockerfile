FROM ubuntu:latest

MAINTAINER Antoine Karcher <antoine.karcher.id@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y build-essential cmake git && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /Projects

RUN cd /Projects && \
    git clone https://github.com/tonykero/Moe.git
