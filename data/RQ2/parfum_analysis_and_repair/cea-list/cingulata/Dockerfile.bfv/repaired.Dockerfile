#######################################
# Cingulata with in-house B/FV SHE implementation
#
# docker build -t cingulata:bfv -f Dockerfile.bfv --build-arg uid=$(id -u) .
# xhost +local:`docker inspect --format='{{ .Config.Hostname }}' $(docker ps -l -q)`
# docker run -it --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"   --rm -v $(pwd):/cingu cingulata:bfv
#######################################

FROM ubuntu:18.04

# install dependencies
RUN ln -snf /usr/share/zoneinfo/$( curl -f https://ipapi.co/timezone) /etc/localtime
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    ca-certificates \
    cmake \
    curl \
    g++ \
    git \
    libboost-graph-dev \
    libboost-program-options-dev \
    libflint-dev \
    libpugixml-dev \
    make \
    python3 \
    python3-pip \
    tzdata \
    xxd \ 
    yad && rm -rf /var/lib/apt/lists/*;

# install python packages
RUN pip3 install --no-cache-dir \
    networkx \
    numpy


# add user
ARG uid=1000
ARG uname=cingu
RUN useradd -u $uid $uname

USER $uname

ENV build_dir=build_bfv

# compilation command
CMD mkdir -p /cingu/$build_dir \
 && cd /cingu/$build_dir \
 && cmake -DUSE_BFV=ON .. \
 && make

WORKDIR /cingu/
