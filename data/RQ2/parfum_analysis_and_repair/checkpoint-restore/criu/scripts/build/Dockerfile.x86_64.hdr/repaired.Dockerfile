FROM ubuntu:focal

COPY scripts/ci/apt-install /bin/apt-install

RUN apt-install gcc-multilib