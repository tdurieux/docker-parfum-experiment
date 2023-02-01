FROM ubuntu:20.04

LABEL Description="TeamTalk for Ubuntu 20.04"

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get --no-install-recommends -y install tzdata keyboard-configuration && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y make git && rm -rf /var/lib/apt/lists/*;
# Duplicate of /TeamTalk5/Build/Makefile:depend-ubuntu20
RUN apt install --no-install-recommends -y qt5-default libqt5x11extras5-dev qtmultimedia5-dev \
                    libqt5texttospeech5-dev qttools5-dev-tools qttools5-dev doxygen \
                    openjdk-17-jdk ninja-build libpcap-dev junit4 cmake \
                    libssl-dev yasm autoconf libtool pkg-config \
                    libasound2-dev wget python g++ p7zip-full python-pytest && rm -rf /var/lib/apt/lists/*;
