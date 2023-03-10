FROM ubuntu:bionic
RUN apt-get -y update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository --yes ppa:beineri/opt-qt-5.11.0-bionic
RUN add-apt-repository --yes ppa:deadsnakes/ppa
RUN add-apt-repository ppa:andrew-fuller/cmake
RUN apt-get -y update && apt-get install --no-install-recommends -y gcc g++ make git libgl1-mesa-dev libglu1-mesa-dev python3.5 clang vim wget qt5113d cmake build-essential qt511tools && rm -rf /var/lib/apt/lists/*;
VOLUME /mnt/code
WORKDIR /mnt/code

