#Generate a Docker image
FROM ubuntu:15.10
MAINTAINER Moycat
RUN apt-get update && apt-get -y --no-install-recommends install g++ fp-compiler && rm -rf /var/lib/apt/lists/*;
