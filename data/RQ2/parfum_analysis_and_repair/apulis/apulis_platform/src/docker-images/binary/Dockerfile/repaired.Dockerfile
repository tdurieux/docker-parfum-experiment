#FROM mlcloudreg.westus.cloudapp.azure.com:5000/dlworkspace/hyperkube:v1.5.0_coreos.multigpu
FROM ubuntu:16.04
MAINTAINER Jin Li <jinlmsft@hotmail.com>

RUN apt-get update -y && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN mkdir /download
WORKDIR /download
RUN wget https://ccsdatarepo.westus.cloudapp.azure.com/data/containernetworking/cni-amd64-v0.5.2.tgz
RUN wget https://ccsdatarepo.westus.cloudapp.azure.com/data/tools/mysql-connector-python_2.1.5-1ubuntu14.04_all.deb
ENV NVIDIA_VERSION=375.20
RUN wget https://ccsdatarepo.westus.cloudapp.azure.com/data/nvidia_drivers/NVIDIA-Linux-x86_64-$NVIDIA_VERSION.run
RUN wget https://ccsdatarepo.westus.cloudapp.azure.com/data/tools/mysql-connector-python_2.1.7-1ubuntu16.04_all.deb
