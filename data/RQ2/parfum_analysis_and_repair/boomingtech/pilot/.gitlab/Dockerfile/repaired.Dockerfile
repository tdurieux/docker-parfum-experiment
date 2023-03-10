FROM ubuntu:20.04
RUN apt update && DEBIAN_FRONTEND=noninteractive TZ=Asia/Shanghai apt --no-install-recommends install -y \
    libxrandr-dev libxrender-dev libxinerama-dev libxcursor-dev \
    libxi-dev libglvnd-dev libvulkan-dev clang libc++-dev libglew-dev \
    libglfw3-dev vulkan-validationlayers mesa-vulkan-drivers wget \
    build-essential libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN cd && wget https://cmake.org/files/v3.23/cmake-3.23.1.tar.gz \
    && tar xf cmake-3.23.1.tar.gz \
    && cd cmake-3.23.1 \
    && ./bootstrap \
    && make \
    && make install \
    && ln -s /usr/local/bin/cmake /usr/bin/cmake && rm cmake-3.23.1.tar.gz

