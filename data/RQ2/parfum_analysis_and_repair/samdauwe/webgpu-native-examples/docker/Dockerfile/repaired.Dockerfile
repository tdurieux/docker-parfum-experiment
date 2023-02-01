# Ubuntu 20.04 (Focal Fossa)
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yq \
        sudo \
        wget \
        git ca-certificates openssl \

        pkg-config build-essential cmake python3 \

        libxi-dev libxcursor-dev libxinerama-dev libxrandr-dev mesa-common-dev \
        xcb libxcb-xkb-dev x11-xkb-utils libx11-xcb-dev libxkbcommon-x11-dev \

        libavdevice-dev \

        libvulkan1 libvulkan-dev mesa-vulkan-drivers vulkan-utils && rm -rf /var/lib/apt/lists/*;

# Remove sudoer password
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
