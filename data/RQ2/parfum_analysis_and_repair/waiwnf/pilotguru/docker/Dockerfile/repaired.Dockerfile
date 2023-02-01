FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

RUN apt-get update

# Get newer QT libraries and QTCreator.
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:kubuntu-ppa/backports
RUN apt-get update

RUN apt-get -y --no-install-recommends install \
    git \
    cmake \
    wget \
    libgoogle-glog-dev \
    protobuf-compiler \
    libprotobuf-dev \
    libglew-dev \
    libeigen3-dev \
    libopenblas-dev \
    liblapack-dev \
    libopencv-dev \
    libav-tools && rm -rf /var/lib/apt/lists/*;

RUN mkdir /opt/pangolin && \
    cd /opt/pangolin && \
    wget https://codeload.github.com/stevenlovegrove/Pangolin/tar.gz/v0.5 && \
    tar -xzf v0.5 && \
    mkdir Pangolin-0.5/build && \
    cd Pangolin-0.5/build && \
    cmake .. && \
    make -j4 && \
    make install

RUN cd /usr/include/ && wget https://github.com/nlohmann/json/releases/download/v2.1.1/json.hpp

RUN apt-get -y --no-install-recommends install \
    libavformat-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavutil-dev \
    libswscale-dev \
    libavresample-dev \
    libavfilter-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install libcupti-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install \
    gdb \
    libxss1 \
    xterm \
    sudo \
    libgconf-2-4 \
    valgrind \
    clang-format \
    curl && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install autoconf libtool psmisc net-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install qtcreator qtbase5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-zmq libzmq3-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;

# CPU-only tensorflow since we only actually use tensorboard, and
# tensorflow does not support CUDA9 yet.
RUN pip3 install --no-cache-dir av==0.4.1 torchvision jupyter opencv-python scipy sklearn sk-video tensorflow tensorboard_logger matplotlib==2.2.4 gpustat

# html5lib versioning is somehow messed up and tensorboard fails to
# start. This somehow installs the versions such that everything works.
# No idea why or how.
RUN pip3 install --no-cache-dir --upgrade bleach

RUN mkdir /opt/install && \
    cd /opt/install && \
    curl -f https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor > microsoft.gpg && \
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
RUN apt-get update
RUN apt-get -y --no-install-recommends install code && rm -rf /var/lib/apt/lists/*;

