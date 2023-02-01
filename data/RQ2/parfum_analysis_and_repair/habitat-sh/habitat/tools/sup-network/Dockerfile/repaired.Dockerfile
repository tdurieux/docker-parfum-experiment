FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install --no-install-recommends -y \
            libczmq-dev \
            libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
            jq \
            curl && rm -rf /var/lib/apt/lists/*;

RUN useradd --user-group hab
