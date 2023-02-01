# Basic image to compile
FROM ubuntu:20.04
MAINTAINER Sten Feldman <exile@chamber.ee>
RUN apt-get update && apt-get install --no-install-recommends -y lib32stdc++6 make && rm -rf /var/lib/apt/lists/*;
CMD "/usr/bin/make"
