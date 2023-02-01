# File to build docker (https://www.docker.com) images to run dispycosnode containers.

# This file builds pycos (https://pycos.org) with Python 3 using latest Ubuntu Linux.

FROM ubuntu:latest

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yq libpython3-dev python3-pip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  pip3 install --no-cache-dir pycos psutil netifaces

CMD ["/usr/local/bin/dispycosnode.py"]
