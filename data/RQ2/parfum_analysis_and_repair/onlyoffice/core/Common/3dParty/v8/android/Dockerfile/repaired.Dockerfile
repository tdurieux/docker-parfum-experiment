############################################################
# Dockerfile to build V8  container images
# Based on Ubuntu
############################################################
# Set the base image to Ubuntu
FROM ubuntu:14.04
# File Author / Maintainer
MAINTAINER onlyoffice.com
################## BEGIN INSTALLATION ######################
# Update Image
RUN apt-get update
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
user docker
# Update depedency of V8
RUN sudo apt-get install --no-install-recommends -y \
                lsb-core \
                git \
                python \
                lbzip2 \
                curl \
                wget \
                xz-utils \
                zip && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/docker
RUN mkdir v8
WORKDIR /home/docker/v8
COPY ./build.sh ./build.sh
RUN ./build.sh
RUN zip -r ./build.zip ./build/*
RUN ls -al /home/docker/v8/build.zip
#End of docker Command