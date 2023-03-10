#################################################
# OpenSees

# Largery based on stevemock/docker-opensees
# All commands are the same as the ones from the base image
# To obtain the results in the final folder, simply run
# License: Apache License 2.0

#################################################


FROM ubuntu:16.04
MAINTAINER Stephen Mock <mock@tacc.utexas.edu>
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install curl emacs make tcl8.5 tcl8.5-dev gcc g++ gfortran && \
    useradd --create-home ubuntu && \
    cd /home/ubuntu && \
    mkdir bin lib && \
    curl -f -L -O https://github.com/OpenSees/OpenSees/archive/v2.4.5.tar.gz && \
    tar -xvzf v2.4.5.tar.gz && mv OpenSees-2.4.5/ OpenSees/ && \
    cd OpenSees && \
    cp MAKES/Makefile.def.EC2-UBUNTU Makefile.def && \
    cp /usr/lib/x86_64-linux-gnu/libtcl8.5.so /usr/lib/libtcl8.5.so && \
    make && mkdir /data && chown -R ubuntu:ubuntu /home/ubuntu /data && \
    mkdir -p /root/shared/results && \
    # Deletes unncessary data
    rm -rf /home/ubuntu/OpenSees && rm v2.4.5.tar.gz && rm -rf /var/lib/apt/lists/*;

USER root
WORKDIR /data
ENV PATH $PATH:/home/ubuntu/bin
