FROM ubuntu:18.04
LABEL maintainer="zwimer@gmail.com"

# Dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yq git make cmake && rm -rf /var/lib/apt/lists/*;

# Clone
RUN git clone --depth 1 --single-branch \
	https://github.com/zwimer/C-bind

# Build
RUN    mkdir ./C-bind/build/ \
    && cd ./C-bind/build/ \
    && cmake ../examples \
    && make

# Execute
ENTRYPOINT cd ./C-bind/build/ && /bin/bash
