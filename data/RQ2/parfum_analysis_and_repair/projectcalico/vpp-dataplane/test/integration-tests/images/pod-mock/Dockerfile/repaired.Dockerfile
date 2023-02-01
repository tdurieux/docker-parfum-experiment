FROM ubuntu:20.04

LABEL maintainer="figschwa@cisco.com"

RUN apt-get update && apt-get install --no-install-recommends -y iproute2 && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
