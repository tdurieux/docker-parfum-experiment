# Image: introlab3it/rtabmap:bionic

FROM ros:melodic-perception

# Install build dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y git software-properties-common ros-melodic-rtabmap-ros && \
    apt-get remove -y ros-melodic-rtabmap && \
    rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/

# GTSAM
RUN add-apt-repository ppa:borglab/gtsam-release-4.0 -y
RUN apt install --no-install-recommends libgtsam-dev libgtsam-unstable-dev -y && rm -rf /var/lib/apt/lists/*;

# libpointmatcher
RUN git clone https://github.com/ethz-asl/libnabo.git
#commit February 13 2021
RUN cd libnabo && \
    git checkout 3cab7eed92bd5d4aed997347b8c8a2692a83a532 && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc) && \
    make install && \
    cd && \
    rm -r libnabo
RUN git clone https://github.com/ethz-asl/libpointmatcher.git
#commit April 6 2021
RUN cd libpointmatcher && \
    git checkout 76f99fce0fe69e6384102a0343fdf8d262626e1f && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc) && \
    make install && \
    cd && \
    rm -r libpointmatcher

ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}
RUN echo "I am building for $TARGETPLATFORM"

# arm64
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then ln -s /usr/bin/cmake ~/cmake; fi

# cmake >=3.11 required for amd64 dependencies
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
 apt install --no-install-recommends -y wget && \
    wget -nv https://github.com/Kitware/CMake/releases/download/v3.17.0/cmake-3.17.0-Linux-x86_64.tar.gz && \
    tar -xzf cmake-3.17.0-Linux-x86_64.tar.gz && \
    rm cmake-3.17.0-Linux-x86_64.tar.gz && \
    ln -s ~/cmake-3.17.0-Linux-x86_64/bin/cmake ~/cmake; rm -rf /var/lib/apt/lists/*; fi

# AliceVision v2.4.0 modified (Sept 13 2021)
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
 apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
      libsuitesparse-dev \
      libceres-dev \
      xorg-dev \
      libglu1-mesa-dev; rm -rf /var/lib/apt/lists/*; fi
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then git clone https://github.com/OpenImageIO/oiio.git && \
    cd oiio && \
    git checkout Release-2.0.12 && \
    mkdir build && \
    cd build && \
    cmake -DUSE_PYTHON=OFF -DOIIO_BUILD_TESTS=OFF -DOIIO_BUILD_TOOLS=OFF .. && \
    make -j$(nproc) && \
    make install && \
    cd && \
    rm -r oiio; fi
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then git clone https://github.com/assimp/assimp.git && \
    cd assimp && \
    git checkout 71a87b653cd4b5671104fe49e2e38cf5dd4d8675 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    cd && \
    rm -r assimp; fi
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then git clone https://github.com/alicevision/geogram.git && \
    cd geogram && \
    git checkout v1.7.6 && \
    wget https://gist.githubusercontent.com/matlabbe/1df724465106c056ca4cc195c81d8cf0/raw/b3ed4cb8f9b270833a40d57d870a259eabfa4415/geogram_8b2ae61.patch && \
    git apply geogram_8b2ae61.patch && \
    ./configure.sh && \
    cd build/Linux64-gcc-dynamic-Release && \
    make -j$(nproc) && \
    make install && \
    cd && \
    rm -r geogram; fi
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then git clone https://github.com/alicevision/AliceVision.git --recursive && \
    cd AliceVision && \
    git checkout 0f6115b6af6183c524aa7fcf26141337c1cf3872 && \
    wget https://gist.githubusercontent.com/matlabbe/1df724465106c056ca4cc195c81d8cf0/raw/b3ed4cb8f9b270833a40d57d870a259eabfa4415/alicevision_0f6115b.patch && \
    git apply alicevision_0f6115b.patch && \
    mkdir build && \
    cd build && \
    ~/cmake -DALICEVISION_USE_CUDA=OFF -DALICEVISION_USE_APRILTAG=OFF -DALICEVISION_BUILD_SOFTWARE=OFF .. && \
    make -j$(nproc) && \
    make install && \
    cd && \
    rm -r AliceVision; fi

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Copy current source code
COPY . /root/rtabmap

# Build RTAB-Map project
RUN source /ros_entrypoint.sh && \
    cd rtabmap/build && \
    ~/cmake -DWITH_ALICE_VISION=ON .. && \
    make -j$(nproc) && \
    make install && \
    cd ../.. && \
    rm -rf rtabmap && \
    ldconfig

