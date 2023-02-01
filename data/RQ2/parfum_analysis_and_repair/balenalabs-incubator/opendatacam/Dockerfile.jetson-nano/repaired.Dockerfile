FROM balenalib/jetson-nano-ubuntu:bionic-run-20201118

WORKDIR /usr/src/app

#OpenDataCam 3.0.2

ENV DEBIAN_FRONTEND noninteractive

# Install some utils
RUN apt-get update && apt-get install --no-install-recommends -y lbzip2 git wget unzip jq && rm -rf /var/lib/apt/lists/*;

# Keep sources list at r32 for cuda 10 and cudnn 7
RUN sed -i 's/r32.4 main/r32 main/g' /etc/apt/sources.list.d/nvidia.list && apt-get update

# Install CUDA/cuDNN
RUN apt-get install --no-install-recommends -y cuda-toolkit-10-0 libcudnn7 libcudnn7-dev && rm -rf /var/lib/apt/lists/*;

# Set paths
ENV CUDA_HOME=/usr/local/cuda-10.0
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CUDA_HOME}/lib64
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV UDEV=1
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

# Download and install BSP binaries for L4T 32.4.2
RUN apt-get update && apt-get install --no-install-recommends -y wget tar lbzip2 python3 libegl1 && \
    wget https://developer.nvidia.com/embedded/L4T/r32_Release_v4.2/t210ref_release_aarch64/Tegra210_Linux_R32.4.2_aarch64.tbz2 && \
    tar xf Tegra210_Linux_R32.4.2_aarch64.tbz2 && \
    cd Linux_for_Tegra && \
    sed -i 's/config.tbz2\"/config.tbz2\" --exclude=etc\/hosts --exclude=etc\/hostname/g' apply_binaries.sh && \
    sed -i 's/install --owner=root --group=root \"${QEMU_BIN}\" \"${L4T_ROOTFS_DIR}\/usr\/bin\/\"/#install --owner=root --group=root \"${QEMU_BIN}\" \"${L4T_ROOTFS_DIR}\/usr\/bin\/\"/g' nv_tegra/nv-apply-debs.sh && \
    sed -i 's/LC_ALL=C chroot . mount -t proc none \/proc/ /g' nv_tegra/nv-apply-debs.sh && \
    sed -i 's/umount ${L4T_ROOTFS_DIR}\/proc/ /g' nv_tegra/nv-apply-debs.sh && \
    sed -i 's/chroot . \//  /g' nv_tegra/nv-apply-debs.sh && \
    ./apply_binaries.sh -r / --target-overlay && cd .. \
    rm -rf Tegra210_Linux_R32.4.2_aarch64.tbz2 && \
    rm -rf Linux_for_Tegra && \
    echo "/usr/lib/aarch64-linux-gnu/tegra" > /etc/ld.so.conf.d/nvidia-tegra.conf && ldconfig && rm -rf /var/lib/apt/lists/*;

# install some OpenCV prerequesets
RUN \
  apt-get install --no-install-recommends -y libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev libwebp-dev libtbb2 libtbb-dev libgstreamer1.0-0 \
  gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad cmake pkg-config && rm -rf /var/lib/apt/lists/*;

# Copy/expand prebuilt OpenCV 4.1.1
COPY opencv411_include.tar.gz .
COPY opencv411_lib.tar.gz .

RUN tar -xvf opencv411_lib.tar.gz -C /usr/local && tar -xvf opencv411_include.tar.gz -C /usr/local/include && rm opencv411_lib.tar.gz

WORKDIR /

# Download and build Darknet
RUN \
  git clone --depth 1 -b odc https://github.com/opendatacam/darknet

WORKDIR /darknet

COPY ./Makefile.jetson-nano ./Makefile

RUN make && ldconfig

#get weights
RUN wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-tiny.weights --no-check-certificate > /dev/null 2>&1

# Download and install OpenDataCam
# first install node.js
RUN \
  curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
  apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN \
  git clone --depth 1 https://github.com/opendatacam/opendatacam.git  /var/local/opendatacam

WORKDIR /var/local/opendatacam

RUN \
  npm install && \
  npm run build && npm cache clean --force;

EXPOSE 8080 8070 8090

COPY config.jetson-nano config.bak

COPY launch.sh launch.sh
RUN chmod 777 launch.sh
CMD ["./launch.sh"]
