# Docker build environment for Ubuntu 20.04

FROM ubuntu:20.04

RUN apt-get update
RUN apt-get -y --no-install-recommends install less htop build-essential vim ruby && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install openjdk-8-jdk-headless maven ant && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gfortran libopenblas-serial-dev && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-arm64/jre/bin/java

CMD mkdir /home/dev
WORKDIR /home/dev