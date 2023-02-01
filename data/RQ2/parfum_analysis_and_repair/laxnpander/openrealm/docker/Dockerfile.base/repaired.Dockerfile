FROM nvidia/cuda:10.0-devel-ubuntu18.04

ARG DEBIAN_FRONTEND=noninteractive

# Basic deps
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    pkg-config \
    git \
    wget \
    curl \
    unzip \
    cmake \
    sudo \
    apt-utils && rm -rf /var/lib/apt/lists/*;

RUN cd / && wget https://raw.githubusercontent.com/laxnpander/OpenREALM/dev/tools/install_opencv.sh

RUN cd / && sed -i 's/sudo //g' install_opencv.sh && bash install_opencv.sh && cd ~ && rm -rf *

RUN wget https://raw.githubusercontent.com/laxnpander/OpenREALM/dev/tools/install_deps.sh

RUN cd / && sed -i 's/sudo //g' install_deps.sh && apt-get update && export DEBIAN_FRONTEND=noninteractive && \  
	bash install_deps.sh && rm -rf /var/lib/apt/lists/*

RUN cd ~ && rm -rf *

CMD ["/bin/bash"]
