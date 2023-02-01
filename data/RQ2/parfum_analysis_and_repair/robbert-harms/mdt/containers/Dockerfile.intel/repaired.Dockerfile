FROM ubuntu:16.04

RUN mkdir -p /src
COPY containers/silent.cfg /src

# install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y lsb-core wget && rm -rf /var/lib/apt/lists/*;

# install Intel OpenCL runtime
RUN cd /src && \
    wget https://registrationcenter-download.intel.com/akdlm/irc_nas/9019/opencl_runtime_16.1.1_x64_ubuntu_6.4.0.25.tgz && \
	tar -xvzf opencl_runtime_16.1.1_x64_ubuntu_6.4.0.25.tgz && \
	mv silent.cfg opencl_runtime_16.1.1_x64_ubuntu_6.4.0.25 && \
	cd opencl_runtime_16.1.1_x64_ubuntu_6.4.0.25 && \
	./install.sh --silent silent.cfg --cli-mode && rm opencl_runtime_16.1.1_x64_ubuntu_6.4.0.25.tgz

# install mdt
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && add-apt-repository ppa:robbert-harms/cbclab && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y python3-mdt python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir tatsu==4.2.6
