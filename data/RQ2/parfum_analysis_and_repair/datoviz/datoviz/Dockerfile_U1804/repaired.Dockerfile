# NOTE: this dockerfile compiles but doesn't work yet
# TODO: start from an nvidia docker instead

FROM ubuntu:18.04

LABEL maintainer "Datoviz Development Team"


# Install the build and lib dependencies, install vulkan and a recent version of CMake
RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y build-essential git wget ninja-build xcb libx11-xcb-dev libxcb-glx0 \
    libglfw3-dev libpng-dev libavcodec-dev libavformat-dev \
    libavfilter-dev libavutil-dev libswresample-dev libfreetype6-dev libassimp-dev \
    && wget -q --show-progress --progress=bar:force:noscroll \
    https://github.com/Kitware/CMake/releases/download/v3.18.3/cmake-3.18.3-Linux-x86_64.sh \
    -O /tmp/cmake-3.18.3-Linux-x86_64.sh \
    && yes | bash /tmp/cmake-3.18.3-Linux-x86_64.sh \
    && ln -s /cmake-3.18.3-Linux-x86_64/bin/cmake /usr/bin/cmake \
    && rm -rf /tmp/cmake* && rm -rf /var/lib/apt/lists/*;


# install nvidia driver
ENV NVIDIA_DRIVER_VERSION=450.66
RUN wget -q --show-progress --progress=bar:force:noscroll \
    https://us.download.nvidia.com/XFree86/Linux-x86_64/$NVIDIA_DRIVER_VERSION/NVIDIA-Linux-x86_64-$NVIDIA_DRIVER_VERSION.run \
    -O /tmp/NVIDIA-Linux-x86_64-$NVIDIA_DRIVER_VERSION.run \
    && cd /tmp \
    && sh NVIDIA-Linux-x86_64-$NVIDIA_DRIVER_VERSION.run --extract-only \
    && cp /tmp/NVIDIA-Linux-x86_64-$NVIDIA_DRIVER_VERSION/libnvidia-cbl.so.$NVIDIA_DRIVER_VERSION /usr/lib/x86_64-linux-gnu/ \
    && cp /tmp/NVIDIA-Linux-x86_64-$NVIDIA_DRIVER_VERSION/libnvidia-glvkspirv.so.$NVIDIA_DRIVER_VERSION /usr/lib/x86_64-linux-gnu/ \
    && cp /tmp/NVIDIA-Linux-x86_64-$NVIDIA_DRIVER_VERSION/libnvidia-rtcore.so.$NVIDIA_DRIVER_VERSION /usr/lib/x86_64-linux-gnu/ \
    && rm -rf /tmp/NVIDIA-Linux-x86_64-$NVIDIA_DRIVER_VERSION /tmp/NVIDIA-Linux-x86_64-$NVIDIA_DRIVER_VERSION.run


# install vulkan sdk
ENV VULKAN_SDK_VERSION=1.2.148.1
RUN echo "downloading Vulkan SDK $VULKAN_SDK_VERSION" \
    && wget -q --show-progress --progress=bar:force:noscroll \
    "https://sdk.lunarg.com/sdk/download/$VULKAN_SDK_VERSION/linux/vulkansdk-linux-x86_64-$VULKAN_SDK_VERSION.tar.gz?Human=true" \
    -O /tmp/vulkansdk-linux-x86_64-$VULKAN_SDK_VERSION.tar.gz \
    && echo "installing Vulkan SDK $VULKAN_SDK_VERSION" \
    && mkdir -p /opt/vulkan \
    && tar -xf /tmp/vulkansdk-linux-x86_64-$VULKAN_SDK_VERSION.tar.gz -C /opt/vulkan \
    &&  rm /tmp/vulkansdk-linux-x86_64-$VULKAN_SDK_VERSION.tar.gz
ENV VULKAN_SDK=/opt/vulkan/${VULKAN_SDK_VERSION}/x86_64
ENV PATH="$VULKAN_SDK/bin:$PATH" \
    LD_LIBRARY_PATH="$VULKAN_SDK/lib:${LD_LIBRARY_PATH:-}" \
    VK_LAYER_PATH="$VULKAN_SDK/etc/vulkan/explicit_layer.d"
# COPY ./nvidia_icd.json /usr/share/vulkan/icd.d/nvidia_icd.json
# wget https://sdk.lunarg.com/sdk/download/latest/linux/vulkan-sdk.tar.gz && \
# mkdir vulkan && tar -xf vulkan-sdk.tar.gz -C vulkan --strip-components 1 && \


# Add the code (TODO: replace with git clone later)
# NOTE: to avoid conflicts with cmake cache, clone another copy of the repo locally in ./experimental/
ADD ./experimental/datoviz /datoviz
WORKDIR /datoviz
RUN ./manage.sh build


ENV container docker
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}display,graphics,utility
ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8

# ARG USER=datoviz
# ARG UID=1000
# ENV HOME /home/$USER
# RUN adduser $USER --uid $UID --disabled-password --gecos "" \
#     && usermod -aG audio,video $USER \
#     && echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# USER $USER
# WORKDIR $HOME

# RUN ./manage.sh run app_blank
