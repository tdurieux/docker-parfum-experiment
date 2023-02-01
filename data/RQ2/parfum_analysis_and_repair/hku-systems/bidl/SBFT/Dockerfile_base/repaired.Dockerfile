FROM ubuntu:18.04

COPY . /home/SBFT
WORKDIR /home/SBFT

RUN apt update &&           \
    ./install_deps.sh && \
    apt install --no-install-recommends -y iproute2 iputils-ping && rm -rf /var/lib/apt/lists/*;