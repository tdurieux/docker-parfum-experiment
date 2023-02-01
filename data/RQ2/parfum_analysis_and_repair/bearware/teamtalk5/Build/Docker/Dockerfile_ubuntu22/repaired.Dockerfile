FROM ubuntu:22.04

LABEL Description="TeamTalk for Ubuntu 22.04"

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get --no-install-recommends -y install tzdata keyboard-configuration && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y make git && rm -rf /var/lib/apt/lists/*;
# Duplicate of /TeamTalk5/Build/Makefile:depend-ubuntu20
RUN apt install --no-install-recommends -y qtbase5-dev libqt5x11extras5-dev qtmultimedia5-dev \
                    libqt5texttospeech5-dev qttools5-dev-tools qttools5-dev doxygen \
                    openjdk-18-jdk ninja-build libpcap-dev junit4 cmake \
                    libssl-dev yasm autoconf libtool pkg-config \
                    libasound2-dev wget python2 g++ p7zip-full python3-pytest && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
