FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install packaging-dev equivs && rm -rf /var/lib/apt/lists/*;

RUN useradd -s /bin/bash -m deb
RUN echo >> /etc/sudoers
RUN echo "deb ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER deb
WORKDIR /home/deb
