FROM ubuntu:18.04
# FROM openjdk:11

# install and source ansible
RUN apt-get update && apt-get install --no-install-recommends -y \
    libssl-dev libuv1-dev net-tools libjpeg-dev zlib1g-dev \
    autoconf libtool ssh rsync tcpdump \
    git cmake make vim build-essential \
    python3-pip && rm -rf /var/lib/apt/lists/*;

ENV LANG C.UTF-8
RUN pip3 install --no-cache-dir ansible numpy matplotlib
    # software-properties-common && \
    # apt-add-repository --yes --update ppa:ansible/ansible && \
    # apt install -y ansible


