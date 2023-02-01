FROM ubuntu:16.04
MAINTAINER Zach Latta <zach@hackclub.com>

RUN apt-get update && apt-get install --no-install-recommends -y ledger && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT /bin/bash
