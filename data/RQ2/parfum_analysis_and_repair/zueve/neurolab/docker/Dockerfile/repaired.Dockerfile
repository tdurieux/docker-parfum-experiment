FROM ubuntu:14.04
MAINTAINER Zuev Evgeny <zueves@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y python-numpy python-scipy ipython && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT /bin/bash
