FROM google/cloud-sdk
MAINTAINER Ben Weinstein

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y cmake git libgtk2.0-dev pkg-config libavcodec-dev \
  libavformat-dev libswscale-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y python-dev python-numpy \
  libtbb2 libtbb-dev \
  libjpeg-dev libjasper-dev libdc1394-22-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python-opencv libopencv-dev libav-tools python-pycurl \
  libatlas-base-dev gfortran webp qt5-default libvtk6-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python-pip wget && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip

RUN apt-get update && apt-get install --no-install-recommends -y unzip python-dev python-pip \
   zlib1g-dev libjpeg-dev libblas-dev liblapack-dev libatlas-base-dev \
   libsnappy-dev libyaml-dev gfortran && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pandas python-snappy scipy scikit-learn \
requests uritemplate google-api-python-client

#INSTALL TENSORFLOW
RUN pip install --no-cache-dir tensorflow

#INSTALL OPENCV
RUN cd ~/ &&\
    git clone https://github.com/Itseez/opencv.git --depth 1 &&\
    git clone https://github.com/Itseez/opencv_contrib.git --depth 1 &&\
    cd opencv && mkdir build && cd build && cmake  -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON .. && \
    make -j4 && make install && ldconfig

#BGS Library - Boost
RUN apt-get install --no-install-recommends -y libboost-all-dev && rm -rf /var/lib/apt/lists/*;
#Compile BGS library
RUN git clone https://github.com/andrewssobral/bgslibrary.git && cd bgslibrary && cd build && cmake -DBGS_PYTHON_SUPPORT=ON .. && \
    make

#Share python .so bgs library
RUN PYTHONPATH=${PYTHONPATH}:/bgslibrary/build

#Apache beam for cloud data flow
RUN pip install --no-cache-dir apache_beam

#install gcsfuse
RUN export GCSFUSE_REPO=gcsfuse-jessie && echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list && \
 curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && apt-get update && apt-get install --no-install-recommends -y gcsfuse && rm -rf /var/lib/apt/lists/*;

RUN ln /dev/null /dev/raw1394

