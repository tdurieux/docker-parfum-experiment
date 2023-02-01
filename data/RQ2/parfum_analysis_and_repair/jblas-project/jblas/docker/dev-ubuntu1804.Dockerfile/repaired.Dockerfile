# Docker build environment for Ubuntu 18.04

FROM ubuntu:18.04

RUN apt-get update
RUN apt-get -y --no-install-recommends install less htop build-essential vim ruby && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install openjdk-8-jdk-headless maven ant && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gfortran libopenblas-dev && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

CMD mkdir /home/dev
WORKDIR /home/dev