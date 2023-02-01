#FROM ubuntu:20.04
#FROM nvidia/cuda:11.2.2-runtime-ubuntu18.04
#FROM nvidia/cuda:10.2-runtime-ubuntu16.04
FROM nvidia/cuda:11.1.1-runtime-ubuntu20.04
LABEL maintainer="cannonbeachgoonie@gmail.com"
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y apt-utils && apt-get install --no-install-recommends -y net-tools && apt-get install --no-install-recommends -y iputils-ping && apt-get install --no-install-recommends -y libnuma1 && apt-get install --no-install-recommends -y libssl-dev && apt-get install --no-install-recommends -y tcpdump && rm -rf /var/lib/apt/lists/*;
ADD fillet /usr/bin/fillet
