FROM ubuntu:20.04
RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc libc6-dev ca-certificates linux-headers-generic git && rm -rf /var/lib/apt/lists/*;

RUN apt search linux-headers
RUN ls /usr/src

ENV PATH=$PATH:/rust/bin
