FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y build-essential curl libcurl3 \
  && curl -f -OL https://downloads.dlang.org/releases/2.x/2.077.1/dmd_2.077.1-0_amd64.deb \
  && apt install -y --no-install-recommends ./dmd_2.077.1-0_amd64.deb && rm -rf /var/lib/apt/lists/*;