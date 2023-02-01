FROM debian:stable
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update -y
RUN apt-get -qq install -y \
    cmake \
    build-essential \
    libx11-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libpng-dev \
    libsdl2-dev \
    libxcursor-dev \
    libxrandr-dev \
    libxext-dev \
    libxi-dev \
    libxinerama-dev \
    zlib1g-dev \
    git && \
    apt-get -qq clean

WORKDIR /work/build
CMD ["bash", "-euc", "cmake .. && time make -j $(nproc)"]
