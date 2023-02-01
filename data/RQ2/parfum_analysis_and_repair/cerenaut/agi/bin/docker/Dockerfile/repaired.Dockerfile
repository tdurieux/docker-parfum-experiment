# Dockerfile for AGI Experimental Framework
# Container for deployment of the framework
# http://agi.io

FROM ubuntu:15.04

MAINTAINER Gideon Kowadlo <gideon@agi.io>

RUN apt-get update && apt-get install --no-install-recommends -y \
openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
maven \
git \
curl && rm -rf /var/lib/apt/lists/*;

# Use docker specific variables.sh file (install of default at /bin/variables.sh)
ENV VARIABLES_FILE variables-docker.sh

# Run coordinator
WORKDIR /root/dev/agi/bin
CMD ["./node_coordinator/run.sh"]