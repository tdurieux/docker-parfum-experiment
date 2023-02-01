FROM ubuntu:16.04

RUN apt-get update && apt-get -y --no-install-recommends install gcc make g++ && rm -rf /var/lib/apt/lists/*;
