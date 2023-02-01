FROM ubuntu:20.04

RUN apt update -y \
    && apt upgrade -y \
    && DEBIAN_FRONTEND="noninteractive" apt --no-install-recommends install -y \
         cmake \
         g++ \
         git \
         libssl-dev \
         make \
    && apt-get autoclean && rm -rf /var/lib/apt/lists/*;
