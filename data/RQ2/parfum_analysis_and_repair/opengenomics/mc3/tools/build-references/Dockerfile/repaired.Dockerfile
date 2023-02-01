FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y wget python python-pip zlib1g-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt

