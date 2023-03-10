FROM ubuntu:18.04
#MAINTAINER Tabish Rashid

# CUDA includes
#ENV CUDA_PATH /usr/local/cuda
#ENV CUDA_INCLUDE_PATH /usr/local/cuda/include
#ENV CUDA_LIBRARY_PATH /usr/local/cuda/lib64

ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
COPY Huawei* /usr/local/share/ca-certificates/

COPY sources.list.bionic /etc/apt/sources.list
COPY pip.conf /root/.pip/
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN update-ca-certificates

#sources.list.bionic

# Ubuntu Packages
RUN apt-get update -y && apt-get install --no-install-recommends software-properties-common -y && \
    add-apt-repository -y multiverse && apt-get update -y && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y apt-utils nano vim man build-essential wget sudo && \
    rm -rf /var/lib/apt/lists/*

# Install curl and other dependencies
RUN apt-get update -y && apt-get install --no-install-recommends -y curl libssl-dev openssl libopenblas-dev \
    libhdf5-dev hdf5-helpers hdf5-tools libhdf5-serial-dev libprotobuf-dev protobuf-compiler git && \
    rm -rf /var/lib/apt/lists/*

# pytorch move to end
#RUN curl -sk https://raw.githubusercontent.com/torch/distro/master/install-deps | bash && \
#    rm -rf /var/lib/apt/lists/*

# for debconf: unable to initialize frontend: Dialog
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils && \
    rm -rf /var/lib/apt/lists/*

# Install python3 pip3
RUN apt-get update && \
    apt-get -y --no-install-recommends install python3 zip && \
    apt-get -y --no-install-recommends install python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip

# Python packages we use (or used at one point...)
RUN pip3 install --no-cache-dir numpy scipy pyyaml matplotlib imageio tensorboard-logger
RUN pip3 install --no-cache-dir pygame jsonpickle==0.9.6 setuptools

RUN mkdir /install
WORKDIR /install

#RUN pip3 install jsonpickle==0.9.6
# install Sacred (from OxWhirl fork)
#RUN pip3 install setuptools
RUN git clone https://github.com/oxwhirl/sacred.git /install/sacred && cd /install/sacred && python3 setup.py install

#### -------------------------------------------------------------------
#### install pytorch
#### -------------------------------------------------------------------
#RUN pip3 install torch
#RUN pip3 install torch==1.4.0+cpu torchvision==0.5.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
# CPU Only
# CPU only
RUN pip3 install --no-cache-dir torch==1.2.0+cpu torchvision==0.4.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
RUN pip3 install --no-cache-dir Ipython torchvision snakeviz pytest probscale


## -- SMAC
RUN pip3 install --no-cache-dir git+https://github.com/oxwhirl/smac.git
#ENV SC2PATH /pymarl/3rdparty/StarCraftII
ENV SC2PATH /pymarl-sim/StarCraftII

#RUN groupadd -r docker && useradd -r -g docker docker
## xingtian
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install --no-install-recommends -y libopencv-dev && \
    apt-get install --no-install-recommends -y redis-server python3-tk && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade setuptools

RUN pip3 install --no-cache-dir opencv-python psutil zmq fabric2 h5py gym[atari] tqdm \
    imageio matplotlib==3.0.3 Ipython pyyaml tensorflow==1.15.0 pyarrow==0.14.0 \
    lz4 redis pylint absl-py line_profiler

# rl simulation
WORKDIR /install
COPY src_zip/rl-simulator-master.zip /install

#VOLUME ["/var/run/docker.sock:/var/run/docker.sock"]

#RUN unzip rl-simulator-master.zip && \
#    cd rl-simulator-master/ && \
#    python3 deploy.py torcs && \
#    python3 deploy.py cavityfilter

# sumo
RUN add-apt-repository ppa:sumo/stable && apt-get update -y && \
    apt-get install --no-install-recommends sumo sumo-tools sumo-doc -y && \
    rm -rf /var/lib/apt/lists/*

ENV SUMO_HOME=/usr/share/sumo

WORKDIR /
