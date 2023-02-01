FROM ubuntu:14.04
MAINTAINER Brandon Amos <brandon.amos.cs@gmail.com>

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    curl \
    gfortran \
    git \
    libatlas-dev \
    libavcodec-dev \
    libavformat-dev \
    libboost-all-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    python-dev \
    python-pip \
    wget \
    zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip2 install numpy scipy pandas
RUN pip2 install scikit-learn scikit-image

RUN curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash -e
RUN git clone https://github.com/torch/distro.git ~/torch --recursive
RUN cd ~/torch && ./install.sh

RUN ~/torch/install/bin/luarocks install nn
RUN ~/torch/install/bin/luarocks install dpnn
RUN ~/torch/install/bin/luarocks install image
RUN ~/torch/install/bin/luarocks install optim
RUN ~/torch/install/bin/luarocks install csvigo

RUN cd ~ && \
    mkdir -p src && \
    cd src && \
    curl -L https://github.com/Itseez/opencv/archive/2.4.11.zip -o ocv.zip && \
    unzip ocv.zip && \
    cd opencv-2.4.11 && \
    mkdir release && \
    cd release && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          .. && \
    make -j8 && \
    make install

RUN cd ~ && \
    mkdir -p src && \
    cd src && \
    curl -L \
         https://github.com/davisking/dlib/releases/download/v18.16/dlib-18.16.tar.bz2 \
         -o dlib.tar.bz2 && \
    tar xf dlib.tar.bz2 && \
    cd dlib-18.16/python_examples && \
    mkdir build && \
    cd build && \
    cmake ../../tools/python && \
    cmake --build . --config Release && \
    cp dlib.so ..

EXPOSE 9000
