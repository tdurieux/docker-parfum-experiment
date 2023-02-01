FROM ubuntu:16.04

WORKDIR /data
RUN apt-get update
RUN apt-get install --no-install-recommends -y libopenmpi-dev openmpi-bin mpich git pkg-config gcc-5 gcc-4.8 nano && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
