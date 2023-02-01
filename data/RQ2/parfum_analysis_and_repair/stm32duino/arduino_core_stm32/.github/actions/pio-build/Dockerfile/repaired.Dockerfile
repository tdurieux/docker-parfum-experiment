# Container image that runs your code
FROM ubuntu:latest

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install prerequisites
RUN apt-get --quiet=2 update && apt-get install -y --no-install-recommends --quiet=2 --assume-yes git python3 python3-pip wget && rm -rf /var/lib/apt/lists/*;

# Install PlatformIO
RUN pip3 install --no-cache-dir --quiet --upgrade platformio
CMD /bin/bash

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]