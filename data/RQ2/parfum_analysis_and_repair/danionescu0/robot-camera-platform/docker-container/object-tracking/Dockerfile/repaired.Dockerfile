FROM balenalib/rpi-raspbian:buster-20190619

RUN apt-get update
RUN apt-get upgrade

# install build depedencies
RUN apt-get install -y --no-install-recommends build-essential \
    ca-certificates \
    cmake \
    gfortran \
    git \
    wget \
    curl \
    zip \
    unzip && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends libpng12-0 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libgtk-3-dev libcanberra-gtk* libatlas-base-dev gfortran python3-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libjpeg-dev libpng-dev libtiff-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libxvidcore-dev libx264-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libgtk-3-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libcanberra-gtk* -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libatlas-base-dev gfortran -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3-dev -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends \
    graphicsmagick \
    libatlas-base-dev \
    libavcodec-dev \
    libavformat-dev \
    libboost-all-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    python3-dev \
    python3-numpy \
    python3-pip \
    libgtk-3-dev \
    libtiff5-dev \
    libjasper-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libatlas-base-dev \
    libraspberrypi0 -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean
RUN pip3 install --no-cache-dir numpy
RUN pip3 install --no-cache-dir wheel
RUN sudo -H pip3 install --no-cache-dir setuptools --upgrade

ENV OPENCV_VERSION 4.1.0

# download opencv
WORKDIR opencv
RUN wget -O opencv.zip https://github.com/Itseez/opencv/archive/$OPENCV_VERSION.zip
RUN unzip opencv.zip
RUN wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/$OPENCV_VERSION.zip
RUN unzip opencv_contrib.zip


# compile opencv
WORKDIR opencv-$OPENCV_VERSION
RUN mkdir build
WORKDIR build
RUN  cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=/opencv/opencv_contrib-$OPENCV_VERSION/modules \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    -D BUILD_TESTS=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D BUILD_EXAMPLES=OFF ..
# adjust swap size for compilation
RUN apt-get install --no-install-recommends -y dphys-swapfile && rm -rf /var/lib/apt/lists/*;
RUN sed -i 's/CONF_SWAPSIZE=100$/CONF_SWAPSIZE=1024/' /etc/dphys-swapfile
RUN /etc/init.d/dphys-swapfile stop
RUN /etc/init.d/dphys-swapfile start
# install opencv
RUN make -j3
RUN make install
RUN ldconfig
# clean up opencv and reduce the image size by deleting files
WORKDIR /
RUN rm -rf /opencv

# install dlib
WORKDIR /root
RUN git clone -b 'v19.6' --single-branch https://github.com/davisking/dlib.git
WORKDIR /root/dlib
RUN python3 setup.py install --compiler-flags "-mfpu=neon"

# install other project dependencies with pip
RUN wget https://files.pythonhosted.org/packages/fa/37/45185cb5abbc30d7257104c434fe0b07e5a195a6847506c074527aa599ec/Click-7.0-py2.py3-none-any.whl
RUN pip3 install --no-cache-dir Click-7.0-py2.py3-none-any.whl
RUN pip3 install --no-cache-dir face_recognition==1.2.3
RUN pip3 install --no-cache-dir picamera==1.13
RUN pip3 install --no-cache-dir imutils==0.4.3
RUN pip3 install --no-cache-dir pyserial==3.4
RUN pip3 install --no-cache-dir Pillow==5.4.1

# install tensorflow
WORKDIR /root
RUN git clone https://github.com/PINTO0309/Tensorflow-bin.git
WORKDIR /root/Tensorflow-bin
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN apt-get install -y --no-install-recommends libhdf5-serial-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends libhdf5-dev && rm -rf /var/lib/apt/lists/*;
RUN mv tensorflow-1.14.0-cp35-cp35m-linux_armv7l.whl tensorflow-1.14.0-cp37-cp37m-linux_armv7l.whl
RUN pip3 install --no-cache-dir tensorflow-1.14.0-cp37-cp37m-linux_armv7l.whl

WORKDIR /workspace