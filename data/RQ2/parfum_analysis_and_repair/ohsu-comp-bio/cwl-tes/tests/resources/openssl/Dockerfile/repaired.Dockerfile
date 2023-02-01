FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;

ENV PATH /usr/local/bin/:/usr/bin:/bin
