FROM ubuntu:16.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y curl g++ gcc git libasound2-dev libbz2-dev libgl1-mesa-dev libglu1-mesa-dev libgtk-3-dev libjack-dev libpulse-dev libssl-dev libudev-dev libva-dev libxinerama-dev libxrandr-dev libxtst-dev make nasm && rm -rf /var/lib/apt/lists/*;

RUN cd ~ && curl -f -L -o cmake.sh https://github.com/Kitware/CMake/releases/download/v3.23.2/cmake-3.23.2-linux-x86_64.sh && sh cmake.sh --skip-license --prefix=/usr/local && rm cmake.sh

CMD /bin/bash
