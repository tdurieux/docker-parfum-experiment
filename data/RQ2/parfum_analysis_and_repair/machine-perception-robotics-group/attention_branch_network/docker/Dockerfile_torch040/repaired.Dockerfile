FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
LABEL maintainer="Tsubasa Hirakawa <hirakawa@mprg.cs.chubu.ac.jp>"

# install base packages
RUN apt-get -y update && apt-get -y upgrade && \
        apt-get install --no-install-recommends -y sudo cmake g++ gfortran \
        libhdf5-dev pkg-config build-essential \
        wget curl git htop tmux vim graphviz ffmpeg \
        libeigen3-dev libgtk-3-dev freeglut3-dev libvtk6-qt-dev \
        libtbb-dev libdc1394-22-dev libavcodec-dev libavformat-dev \
        libswscale-dev libjpeg-dev libjasper-dev libpng++-dev libtiff5-dev \
        libopenexr-dev libwebp-dev libhdf5-dev libopenblas-dev liblapacke-dev \
        libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev \
        tk-dev libgdbm-dev libc6-dev libbz2-dev && \
        apt-get -y autoremove && apt-get -y clean && apt-get -y autoclean && \
        rm -rf /var/lib/apt/lists/*


# cuda path
ENV CUDA_ROOT /usr/local/cuda
ENV PATH $PATH:$CUDA_ROOT/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$CUDA_ROOT/lib64:$CUDA_ROOT/lib:/usr/local/nvidia/lib64:/usr/local/nvidia/lib
ENV LIBRARY_PATH /usr/local/nvidia/lib64:/usr/local/nvidia/lib:/usr/local/cuda/lib64/stubs:/usr/local/cuda/lib64:/usr/local/cuda/lib$LIBRARY_PATH


# python 3.6
# build python 3.6 from source
RUN wget https://www.python.org/ftp/python/3.6.9/Python-3.6.9.tgz && tar -xvf Python-3.6.9.tgz && \
    cd Python-3.6.9 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared --enable-optimizations && make altinstall && \
    ldconfig && rm -rf /opt/Python-3.6.9.tgz /opt/Python-3.6.9/ && \
    ln -sf /usr/local/bin/python3.6 /usr/local/bin/python3
RUN pip3.6 install --upgrade pip && \
    pip3.6 install --upgrade --no-cache-dir wheel six setuptools cython numpy scipy matplotlib seaborn scikit-learn scikit-image pillow requests jupyterlab networkx h5py pandas plotly protobuf tqdm hacking nose mock converge setproctitle tensorboardx && \
    pip3.6 install https://download.pytorch.org/whl/cu90/torch-0.4.1-cp36-cp36m-linux_x86_64.whl && \
    pip3.6 install torchvision==0.2.1


# opencv install (biuld from source)
WORKDIR /opt
ENV OPENCV_VERSION="3.4.1"
RUN git clone https://github.com/opencv/opencv.git && \
        cd /opt/opencv && git checkout ${OPENCV_VERSION} && \
        mkdir build && cd build && \
        cmake .. -DBUILD_TIFF=ON -DBUILD_opencv_java=OFF \
            -DWITH_CUDA=OFF -DENABLE_AVX=ON -DWITH_OPENGL=ON \
            -DWITH_OPENCL=ON -DWITH_IPP=ON -DWITH_TBB=ON \
            -DWITH_EIGEN=ON -DWITH_V4L=ON -DBUILD_TESTS=OFF \
            -DBUILD_PERF_TESTS=OFF -DCMAKE_BUILD_TYPE=RELEASE \
            -DCMAKE_INSTALL_PREFIX=$(python3.6 -c "import sys; print(sys.prefix)") \
            -DPYTHON_EXECUTABLE=$(which python3.6) \
            -DPYTHON_INCLUDE_DIR=$(python3.6 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
            -DPYTHON_PACKAGES_PATH=$(python3.6 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") .. && \
        make -j8 && make install && \
        echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf && \
        ldconfig && rm -rf /opt/opencv
