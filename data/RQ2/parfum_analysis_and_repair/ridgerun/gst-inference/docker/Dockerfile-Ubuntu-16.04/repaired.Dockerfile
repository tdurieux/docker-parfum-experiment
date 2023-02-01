FROM ubuntu:16.04

# Install all needed packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    apt-utils software-properties-common \
    python3-pip python3-dev \
    libgstreamer1.0-0 gstreamer1.0-plugins-base \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly gstreamer1.0-libav \
    gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x \
    cmake cpputest automake libtool pkg-config \
    unzip doxygen libgtk2.0-dev \
    wget vim \
    libcv2.4 libopencv-contrib-dev libopencv-contrib2.4v5 \
    libopencv-core-dev libopencv-core2.4v5 libopencv-dev \
    libopencv-highgui-dev libopencv-highgui2.4v5 \
    libopencv-imgproc-dev libopencv-imgproc2.4v5 \
    libopencv-legacy-dev libopencv-legacy2.4v5 \
    libopencv-video-dev libopencv-video2.4v5 && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir meson ninja numpy

# Install latest git version
RUN apt-add-repository ppa:git-core/ppa \
    && apt-get update \
    && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Copy tar package with tensorflow and tensorflow lite dependencies
COPY r2inference-dependencies-linux-x86_64-v0.1.0.tar.gz /root

RUN tar -C /root -xzf /root/r2inference-dependencies-linux-x86_64-v0.1.0.tar.gz \
 && rm /root/r2inference-dependencies-linux-x86_64-v0.1.0.tar.gz

CMD ["/bin/bash"]
