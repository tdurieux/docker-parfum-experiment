FROM ubuntu:16.04
MAINTAINER volcano <maintainer@volcano.sh>
RUN apt-get update --fix-missing \
     && apt-get install --no-install-recommends -y libopenmpi-dev openmpi-bin \
     && apt-get install --no-install-recommends -y git \
     && apt-get install --no-install-recommends -y build-essential \
     && apt-get install --no-install-recommends -y ssh \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/wesleykendall/mpitutorial \
    && cd mpitutorial/tutorials/mpi-hello-world/code \
    && make \
    && cp mpi_hello_world /home/ \
    && apt-get autoremove -y git \
    && apt-get autoremove -y build-essential \
    && rm -rf "/mpitutorial"
CMD mkdir -p /var/run/sshd; /usr/sbin/sshd;