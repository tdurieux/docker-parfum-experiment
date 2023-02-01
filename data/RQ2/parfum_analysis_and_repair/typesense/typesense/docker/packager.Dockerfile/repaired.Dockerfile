FROM ubuntu:16.04

RUN apt-get -y update && apt-get -y --no-install-recommends install ca-certificates alien && rm -rf /var/lib/apt/lists/*;
