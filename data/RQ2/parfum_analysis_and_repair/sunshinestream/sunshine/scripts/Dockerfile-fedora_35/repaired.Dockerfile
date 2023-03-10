FROM fedora:35 AS sunshine-fedora_35

# Fedora 35 end of life is TBD

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN dnf -y update && \
    dnf -y group install "Development Tools" && \
    dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf -y install \
        boost-devel \
        boost-static.x86_64 \
        cmake \
        ffmpeg-devel \
        gcc-c++ \
        libevdev-devel \
        libX11-devel \
        libxcb-devel \
        libXcursor-devel \
        libXfixes-devel \
        libXinerama-devel \
        libXi-devel \
        libXrandr-devel \
        libXtst-devel \
        mesa-libGL-devel \
        openssl-devel \
        opus-devel \
        pulseaudio-libs-devel \
        libcap-devel \
        libdrm-devel \
        rpm-build \
    && dnf clean all \
    && rm -rf /var/cache/yum

# Entrypoint
COPY build-private.sh /root/build.sh
ENTRYPOINT ["/root/build.sh", "-rpm"]