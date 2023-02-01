FROM ubuntu:bionic
MAINTAINER manuel.peuster@uni-paderborn.de

RUN apt-get update && apt-get install --no-install-recommends -y \
    net-tools \
    iputils-ping \
    iproute2 && rm -rf /var/lib/apt/lists/*;

CMD /bin/bash
