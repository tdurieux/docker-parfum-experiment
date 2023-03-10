FROM ubuntu:20.04 AS sunshine-2004

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ="Europe/London"

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
    git wget gcc-10 g++-10 build-essential cmake libssl-dev libavdevice-dev libboost-thread-dev libboost-filesystem-dev libboost-log-dev libpulse-dev libopus-dev libxtst-dev libx11-dev libxrandr-dev libxfixes-dev libevdev-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev libdrm-dev libcap-dev libwayland-dev && rm -rf /var/lib/apt/lists/*;

RUN cp /usr/bin/gcc-10 /usr/bin/gcc && cp /usr/bin/g++-10 /usr/bin/gcc-10

RUN wget https://developer.download.nvidia.com/compute/cuda/11.4.2/local_installers/cuda_11.4.2_470.57.02_linux.run --progress=bar:force:noscroll -q --show-progress -O /root/cuda.run && chmod a+x /root/cuda.run
RUN /root/cuda.run --silent --toolkit --toolkitpath=/usr --no-opengl-libs --no-man-page --no-drm && rm /root/cuda.run

COPY build-private.sh /root/build.sh


ENTRYPOINT ["/root/build.sh"]
