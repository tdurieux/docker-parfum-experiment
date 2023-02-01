FROM ubuntu:16.04

RUN apt-get update \
&& apt-get install --no-install-recommends -y gcc g++ python \
&& apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY . /usr/local
