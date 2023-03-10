FROM ubuntu:18.04
RUN apt update
RUN apt install --no-install-recommends -y git wget g++ make git-lfs curl && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install libx11-dev libgl1-mesa-dev libxrandr-dev libxi-dev x11proto-xf86vidmode-dev xorg-dev libglu1-mesa-dev libpulse-dev libgtk-3-dev libopenal-dev zenity && rm -rf /var/lib/apt/lists/*;
RUN wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository universe
RUN apt update
RUN apt -y --no-install-recommends install apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt update
RUN apt -y --no-install-recommends install dotnet-sdk-5.0 && rm -rf /var/lib/apt/lists/*;

RUN \
    git clone --depth 1 https://github.com/effekseer/Effekseer.git \
    && cd Effekseer \
    && git submodule update --init --recommend-shallow --depth 1 \
    && git lfs install \
    && git lfs pull

RUN \
    curl -f -sL https://cmake.org/files/v3.15/cmake-3.15.3-Linux-x86_64.sh -o cmakeinstall.sh \
    && chmod +x cmakeinstall.sh \
    && ./cmakeinstall.sh --prefix=/usr/local --exclude-subdir \
    && rm cmakeinstall.sh

RUN cd Effekseer \
    && python3 build.py
