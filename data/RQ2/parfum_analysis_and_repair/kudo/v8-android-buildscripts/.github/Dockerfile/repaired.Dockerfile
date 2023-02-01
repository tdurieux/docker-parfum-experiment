FROM ubuntu:20.04
MAINTAINER https://github.com/Kudo

RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*; ENV DEBIAN_FRONTEND noninteractive


RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 ubuntu
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER ubuntu
WORKDIR /home/ubuntu
