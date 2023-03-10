ARG CUDA_BASE=nvidia/cuda:10.1-base-ubuntu18.04
# Build the public image:
#   docker build -t horizonrobotics/alf:0.0.3-carla -f Dockerfile.carla .
# To run the simulator:
#   docker run -p 2000-2002:2000-2002 --rm --gpus all -it -u carla horizonrobotics/alf:0.0.3-carla

########################## Build Vulkan #################################
# Adapted from:
# https://gitlab.com/nvidia/container-images/opengl/-/blob/ubuntu18.04/base/Dockerfile
# https://gitlab.com/nvidia/container-images/opengl/-/blob/ubuntu18.04/glvnd/runtime/Dockerfile
# https://gitlab.com/nvidia/container-images/vulkan/-/blob/master/docker/Dockerfile.ubuntu18.04

FROM ubuntu:18.04 as vulkan-khronos

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    git \
    libegl1-mesa-dev \
    libwayland-dev \
    libx11-xcb-dev \
    libxkbcommon-dev \
    libxrandr-dev \
    python3 \
    python3-distutils \
    wget && \
    rm -rf /var/lib/apt/lists/*

ARG VULKAN_VERSION=sdk-1.1.121.0

# Download and compile vulkan components
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    git clone https://github.com/KhronosGroup/Vulkan-ValidationLayers.git /opt/vulkan && \
    cd /opt/vulkan && git checkout "${VULKAN_VERSION}" && \
    mkdir build && cd build && ../scripts/update_deps.py && \
    cmake -C helper.cmake -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build . && make install && ldconfig && \
    mkdir -p /usr/local/lib && cp -a Vulkan-Loader/build/install/lib/* /usr/local/lib && \
    mkdir -p /usr/local/include/vulkan && cp -r Vulkan-Headers/build/install/include/vulkan/* /usr/local/include/vulkan && \
    mkdir -p /usr/local/share/vulkan/registry && \
    cp -r Vulkan-Headers/build/install/share/vulkan/registry/* /usr/local/share/vulkan/registry && \
    rm -rf /opt/vulkan

FROM ${CUDA_BASE}

ENV NVIDIA_DRIVER_CAPABILITIES compute,graphics,utility
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu:/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/nvidia/lib:/usr/local/nvidia/lib64

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --no-install-recommends \
    libxau6 libxau6:i386 \
    libxdmcp6 libxdmcp6:i386 \
    libxcb1 libxcb1:i386 \
    libxext6 libxext6:i386 \
    libx11-6 libx11-6:i386 \
    libglvnd0 libglvnd0:i386 \
    libgl1 libgl1:i386 \
    libglx0 libglx0:i386 \
    libegl1 libegl1:i386 \
    libgles2 libgles2:i386 \
    pkg-config \
    libglvnd-dev libglvnd-dev:i386 \
    libgl1-mesa-dev libgl1-mesa-dev:i386 \
    libegl1-mesa-dev libegl1-mesa-dev:i386 \
    libgles2-mesa-dev libgles2-mesa-dev:i386 \
    libx11-xcb-dev \
    libxkbcommon-dev \
    libwayland-dev \
    libxrandr-dev \
    libegl1-mesa-dev && rm -rf /var/lib/apt/lists/*;

COPY --from=vulkan-khronos /usr/local/bin /usr/local/bin
COPY --from=vulkan-khronos /usr/local/lib /usr/local/lib
COPY --from=vulkan-khronos /usr/local/include/vulkan /usr/local/include/vulkan
COPY --from=vulkan-khronos /usr/local/share/vulkan /usr/local/share/vulkan
COPY ./nvidia_icd.json /etc/vulkan/icd.d/nvidia_icd.json
COPY ./10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json

###################### ALF dependencies #############################
# Adapted from: https://github.com/HorizonRobotics/alf/blob/pytorch/.ci-cd/Dockerfile.cpu

# basic software package
RUN apt update && apt install -y --no-install-recommends \
    build-essential \
    vim tree wget unzip git \
    libxml2 libxml2-dev libxslt1-dev libfreetype6-dev \
    dirmngr gnupg2 lsb-release \
    xvfb kmod swig patchelf ffmpeg rsync \
    libopenmpi-dev libcups2-dev libssl-dev \
    python3.7 python3-pip python3.7-dev python3-setuptools && rm -rf /var/lib/apt/lists/*;

RUN python3.7 -m pip install --upgrade pip

RUN ln -sf /usr/bin/python3.7 /usr/bin/python \
    && ln -sf /usr/bin/python3.7 /usr/bin/python3

COPY ./requirements_carla.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt \
    && rm -rf /tmp/requirements.txt

RUN pip3 install --no-cache-dir git+https://github.com/HorizonRobotics/gin-config.git@50bbde3

RUN pip3 install --no-cache-dir torch==1.8.1+cu101 torchvision==0.9.1+cu101 torchtext==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html


RUN pip3 install --no-cache-dir setuptools==45.2.0

# Uncomment below for hobot cluster usage
#COPY ./set_env.sh /opt/set_env.sh

######################### Install Carla #########################
# Adapted from: https://github.com/carla-simulator/carla/blob/master/Util/Docker/Release.Dockerfile

RUN apt update && apt install -y libsdl2-2.0 --no-install-recommends && rm -rf /var/lib/apt/lists/*;

# clean
RUN  rm -rf /var/lib/apt/lists/* \
     && rm -rf /tmp/package \
     && rm -rf /install

RUN useradd -m carla
USER carla
WORKDIR /home/carla

RUN wget https://carla-releases.s3.eu-west-3.amazonaws.com/Linux/CARLA_0.9.9.tar.gz \
    && tar zxf CARLA_0.9.9.tar.gz \
    && rm CARLA_0.9.9.tar.gz
RUN cd Import && wget https://carla-releases.s3.eu-west-3.amazonaws.com/Linux/AdditionalMaps_0.9.9.tar.gz
RUN sh ImportAssets.sh && rm /home/carla/Import/AdditionalMaps_0.9.9.tar.gz

USER root
RUN cd /home/carla/PythonAPI/carla/dist && python3.7 -m easy_install carla-0.9.9-py3.7-linux-x86_64.egg
RUN pip3 install --no-cache-dir -r /home/carla/PythonAPI/carla/requirements.txt

# On desktop we can't run UE4 in root. Comment the line below for cluster usage
USER carla

ENV SDL_VIDEODRIVER=offscreen
ENV PYTHONPATH=/home/carla/PythonAPI/carla

CMD /bin/bash CarlaUE4.sh
