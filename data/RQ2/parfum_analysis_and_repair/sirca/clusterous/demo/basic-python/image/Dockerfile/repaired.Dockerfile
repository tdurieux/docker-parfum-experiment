FROM ubuntu:14.04
MAINTAINER Balram Ramanathan <balram.ramanathan@sirca.org.au>
RUN apt-get update && apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
