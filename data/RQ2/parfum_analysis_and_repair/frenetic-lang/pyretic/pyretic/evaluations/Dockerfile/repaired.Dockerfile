FROM ubuntu:latest
MAINTAINER Srinivas Narayana <narayana@cs.princeton.edu>
RUN apt-get update && apt-get -y --no-install-recommends install wget && mkdir pyretic && cd pyretic && wget https://www.cs.princeton.edu/~narayana/frenetic && chmod +x frenetic && rm -rf /var/lib/apt/lists/*;
