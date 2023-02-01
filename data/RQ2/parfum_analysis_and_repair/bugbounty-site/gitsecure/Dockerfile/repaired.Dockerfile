# Container image that runs your code
FROM ubuntu:16.04

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

COPY codes/analyze.py /analyze.py

# setting up docker instance.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y curl && \
    apt-get install --no-install-recommends -y python3-dev python3-pip && \
    pip3 install --no-cache-dir requests && \
    chmod +x /entrypoint.sh && rm -rf /var/lib/apt/lists/*;

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
