# Container image that runs your code
FROM ubuntu:latest

# Install prerequisites
RUN apt-get update --quiet=2 && apt-get install -y --no-install-recommends --quiet=2 --assume-yes python3 python3-pip && rm -rf /var/lib/apt/lists/*;
CMD /bin/bash

RUN pip3 install --no-cache-dir codespell
CMD /bin/bash

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
