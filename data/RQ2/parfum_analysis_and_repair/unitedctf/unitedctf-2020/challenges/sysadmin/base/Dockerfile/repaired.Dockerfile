FROM ubuntu:20.04

RUN apt update && apt install --no-install-recommends -y \
    netcat-traditional net-tools iputils-ping curl wget \
    strace ltrace \
    build-essential \
    sudo bash-completion htop \
    nano vim man git && rm -rf /var/lib/apt/lists/*;