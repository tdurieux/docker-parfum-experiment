# https://gitlab.com/nvidia/container-images/samples/-/blob/master/opengl/ubuntu16.04/peglgears/Dockerfile
FROM nvidia/opengl:1.0-glvnd-devel-ubuntu18.04

ENV NVIDIA_REQUIRE_DRIVER "driver>=390"

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        g++ \
        libglew-dev \
        freeglut3-dev && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://mesa.freedesktop.org/archive/demos/8.3.0/mesa-demos-8.3.0.tar.gz -O && \
    tar -xzf mesa-demos-8.3.0.tar.gz -C /opt && \
    rm mesa-demos-8.3.0.tar.gz && \
    cd /opt/mesa-demos-8.3.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-egl=yes && \
    make -j"$(nproc)"

RUN useradd -ms /bin/bash app

WORKDIR /opt/mesa-demos-8.3.0/src/egl/opengl/
USER app

