FROM nvidia/cudagl:11.1-base-ubuntu20.04 AS build
LABEL MAINTAINER="Metalab <metalab-dev@sat.qc.ca>"

# Set switcher paths, we want the commands to run
# from the root switcher sources directory
WORKDIR "/opt/switcher"
COPY . "/opt/switcher"

# Install common dependencies
RUN apt update -y \
    # install shmdata \
    && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y -qq \
        git cmake build-essential \
        libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev python3-dev \
    && git clone https://gitlab.com/sat-metalab/shmdata.git \
    && cd shmdata && mkdir build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make -j$(nproc) && make install && ldconfig && cd ../.. \
    # install switcher dependencies
    && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y -qq \
        $(cat deps/apt-build-ubuntu-20.04) \
        $(cat deps/apt-runtime-ubuntu-20.04) \
        $(cat deps/apt-build-nvidia-deps-ubuntu-20.04) \
        $(cat deps/apt-runtime-nvidia-deps-ubuntu-20.04) \
    # install python dependencies
    && python3 -m pip install -U pip \
    && apt-get remove -y --purge python3-pip \
    && pip3 install --no-cache-dir -r deps/pip3-ubuntu20.04 \
    # Clean apt cache
    && apt-get clean \
    && apt-get autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ && rm -rf /var/lib/apt/lists/*;
