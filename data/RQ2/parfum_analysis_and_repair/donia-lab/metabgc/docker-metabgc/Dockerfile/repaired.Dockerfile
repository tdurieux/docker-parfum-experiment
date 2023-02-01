FROM ubuntu:20.04
MAINTAINER ab50 "ab50@princeton.edu"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install --no-install-recommends -y python3-pip python3-dev \
  && apt-get install --no-install-recommends -y g++ rsync zip make git \
  && apt-get install --no-install-recommends -y muscle=1:3.8.1551-2build1 \
  && apt-get install --no-install-recommends -y hmmer=3.3+dfsg2-1 \
  && apt-get install --no-install-recommends -y ncbi-blast+=2.9.0-2 \
  && apt-get install --no-install-recommends -y cd-hit=4.8.1-2build1 \
  && apt-get install --no-install-recommends -y emboss=6.6.0+dfsg-7ubuntu2 \
  && apt-get install --no-install-recommends -y art-nextgen-simulation-tools=20160605+dfsg-4 \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

