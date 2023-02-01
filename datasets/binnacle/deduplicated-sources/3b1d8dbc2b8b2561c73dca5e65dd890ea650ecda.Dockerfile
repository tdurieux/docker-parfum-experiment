FROM ubuntu:18.10

# Update and install packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y -q build-essential figlet freeglut3-dev g++-mingw-w64-x86-64 git gtk+3-dev libboost-all-dev libc-dev libglew-dev libglibmm-2.4-dev libsdl2-dev libsfml-dev make mesa-common-dev qtbase5-dev qt5-default qtdeclarative5-dev scons python3 apt-utils apt-file libconfig++-dev libconfig++ libopenal-dev libglfw3-dev libvulkan-dev libglm-dev libsdl2-mixer-dev libboost-system-dev libfcgi-dev && \
    apt-get update && \
    apt-get clean

# Install cxx, but don't keep the git checkout in the docker image
RUN git clone https://github.com/xyproto/cxx && \
    cd cxx && \
    make install

# Clean and build most examples
CMD cxx/tests/all.py fastclean:build vulkan vulkan_glfw fastcgi entityx pytorch
