FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y apt-utils && apt-get install --no-install-recommends -y \
    sudo \
    software-properties-common \
    wget && rm -rf /var/lib/apt/lists/*;
RUN cd /opt && \
    bash -c 'bash <(wget -qO- https://raw.githubusercontent.com/davidepatti/noxim/master/other/setup/ubuntu.sh)'
