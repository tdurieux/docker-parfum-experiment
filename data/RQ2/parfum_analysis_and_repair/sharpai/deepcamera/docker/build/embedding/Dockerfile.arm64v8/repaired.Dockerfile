FROM shareai/tensorflow:nano_latest

RUN mkdir -p /root/.ssh
COPY ./id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
COPY ./sshconfig /root/.ssh/config

RUN ls -lh && apt-get update && apt-get install --no-install-recommends -y libopenblas-base && apt-get clean && \
    mkdir -p /root/.local/lib/python2.7/site-packages/ && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /root/requirements.txt
RUN pip install --no-cache-dir -r /root/requirements.txt

RUN wget https://mxnet-public.s3.us-east-2.amazonaws.com/install/jetson/1.6.0/mxnet_cu102-1.6.0-py2.py3-none-linux_aarch64.whl && \
    pip install --no-cache-dir mxnet_cu102-1.6.0-py2.py3-none-linux_aarch64.whl

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y curl wget git build-essential autoconf libtool pkg-config libgflags-dev libboost-dev libboost-all-dev libssl-dev \
            arp-scan libsfml-dev libcurl4-openssl-dev liblog4cplus-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
            gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-bad gstreamer1.0-plugins-good \
            gstreamer1.0-plugins-ugly gstreamer1.0-tools \
            pkg-config libcpputest-dev doxygen \
            gtk-doc-tools libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
            gstreamer1.0-libav unzip && rm -rf /var/lib/apt/lists/*;

RUN echo "Installing cmake 3.18.6" && \
    mkdir /root/temp && \
    cd /root/temp && \
    wget https://cmake.org/files/v3.18/cmake-3.18.6.tar.gz && \
    tar -xzvf cmake-3.18.6.tar.gz && \
    cd cmake-3.18.6/  && \
    ./bootstrap && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /root/temp && rm cmake-3.18.6.tar.gz


RUN cd /root && \
    mkdir opencv && \
    cd opencv && \
    wget -O opencv.zip https://github.com/opencv/opencv/archive/4.1.2.zip && \
    unzip opencv.zip && \
    mv opencv-4.1.2 opencv && \
    wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.1.2.zip && \
    unzip opencv_contrib.zip && \
    mv opencv_contrib-4.1.2 opencv_contrib && \
    mkdir -p build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D BUILD_EXAMPLES=OFF \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D CUDA_FAST_MATH=ON \
    -D WITH_GSTREAMER=ON \
    -D WITH_LIBV4L=ON \
    -D WITH_OPENGL=ON \
    -D ENABLE_FAST_MATH=ON \
    -D ENABLE_NEON=ON \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules \
    ../opencv && \
    cmake --build . -j$(nproc) && \
    make install && \
    rm -rf /root/opencv
RUN pip install --no-cache-dir sqlalchemy==1.3.10 pycuda==2019.1
#RUN wget https://nvidia.box.com/shared/static/1v2cc4ro6zvsbu0p8h6qcuaqco1qcsif.whl -O torch-1.4.0-cp27-cp27mu-linux_aarch64.whl && \
ADD ./assets/iresnet34-5b0d0e90.pth /root/.cache/torch/checkpoints/iresnet34-5b0d0e90.pth
ADD ./assets/iresnet50-7f187506.pth /root/.cache/torch/checkpoints/iresnet50-7f187506.pth
ADD ./assets/torch-1.4.0-cp27-cp27mu-linux_aarch64.whl /root/torch-1.4.0-cp27-cp27mu-linux_aarch64.whl
ADD ./assets/torchvision-0.5.0a0+85b8fbf-cp27-cp27mu-linux_aarch64.whl /root/torchvision-0.5.0a0+85b8fbf-cp27-cp27mu-linux_aarch64.whl
RUN pip install --no-cache-dir /root/torch-1.4.0-cp27-cp27mu-linux_aarch64.whl && \
    pip install --no-cache-dir /root/torchvision-0.5.0a0+85b8fbf-cp27-cp27mu-linux_aarch64.whl && \
    rm /root/torch-1.4.0-cp27-cp27mu-linux_aarch64.whl && \
    rm /root/torchvision-0.5.0a0+85b8fbf-cp27-cp27mu-linux_aarch64.whl