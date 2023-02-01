FROM nvidia/cuda

# TODO REPLACE CUDA_ARCH_BIN with your GPU value: https://developer.nvidia.com/cuda-gpus
# For example my GeForce GTX 1050 is 6.1

# This is a dev image, needed to compile OpenCV with CUDA
# Install  Gstreamer and OpenCV Pre-requisite libs
RUN  apt-get update -y && apt-get install -y \
            libgstreamer1.0-0 \
            gstreamer1.0-plugins-base \
            gstreamer1.0-plugins-good \
            gstreamer1.0-plugins-bad \
            gstreamer1.0-plugins-ugly \
            gstreamer1.0-libav \
            gstreamer1.0-doc \
            gstreamer1.0-tools \
            libgstreamer1.0-dev \
            libgstreamer-plugins-base1.0-dev
RUN  apt-get update -y && apt-get install -y  pkg-config \
 zlib1g-dev  libwebp-dev \
 libtbb2 libtbb-dev  \
 libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev \
 cmake
RUN apt-get install -y \
  autoconf \
  autotools-dev \
  build-essential \
  gcc \
  git
ENV OPENCV_RELEASE_TAG 3.4.5
RUN git clone --depth 1 -b ${OPENCV_RELEASE_TAG}  https://github.com/opencv/opencv.git /var/local/git/opencv
RUN cd /var/local/git/opencv
RUN mkdir -p /var/local/git/opencv/build && \
     cd /var/local/git/opencv/build $$ && \
    cmake -D CMAKE_BUILD_TYPE=Release -D BUILD_PNG=OFF -D \
    BUILD_TIFF=OFF -D BUILD_TBB=OFF -D BUILD_JPEG=ON \
    -D BUILD_JASPER=OFF -D BUILD_ZLIB=ON -D BUILD_EXAMPLES=OFF \
    -D BUILD_opencv_java=OFF -D BUILD_opencv_python2=ON \
    -D BUILD_opencv_python3=OFF -D ENABLE_NEON=OFF -D WITH_OPENCL=OFF \
    -D WITH_OPENMP=OFF -D WITH_FFMPEG=OFF -D WITH_GSTREAMER=ON -D WITH_GSTREAMER_0_10=OFF \
    -D WITH_CUDA=ON -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda/ -D WITH_GTK=ON \
    -D WITH_VTK=OFF -D WITH_TBB=ON -D WITH_1394=OFF -D WITH_OPENEXR=OFF \
     -D CUDA_ARCH_BIN=6.1 -D CUDA_ARCH_PTX="" -D INSTALL_C_EXAMPLES=OFF -D INSTALL_TESTS=OFF ..
RUN  cd /var/local/git/opencv/build && \ 
      make install

# Checkout and build darknet
# for debug
# apt-get install -y --no-install-recommends vim 

RUN git clone --depth 1 -b opendatacam https://github.com/opendatacam/darknet /var/local/darknet
WORKDIR /var/local/darknet
RUN sed -i -e s/GPU=0/GPU=1/ Makefile;
# For some reason no need for a CUDNN=1 on my CUDA_ARCH_BIN=6.1
RUN sed -i -e s/OPENCV=0/OPENCV=1/ Makefile;
RUN make

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    vim \
    wget \
    ;

# Get weights files
RUN wget https://pjreddie.com/media/files/yolov3.weights -O /var/local/darknet/yolov3.weights
RUN wget https://pjreddie.com/media/files/yolov3-tiny.weights -O /var/local/darknet/yolov3-tiny.weights
RUN mkdir /var/local/darknet/opendatacam_videos && wget https://github.com/opendatacam/opendatacam/raw/v2.0.0-beta.2/static/demo/demo.mp4 -O /var/local/darknet/opendatacam_videos/demo.mp4

# wget -N https://github.com/opendatacam/opendatacam/raw/v2.0.0-beta.2/static/demo/demo.mp4
# Debug, test darknet : ./darknet detector demo cfg/coco.data cfg/yolov3.cfg yolov3.weights -ext_output -dont_show demo.mp4
# Debug, test darknet : ./darknet detector demo cfg/coco.data cfg/yolov3-tiny.cfg yolov3-tiny.weights -ext_output -dont_show demo.mp4

# Install node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

# Install mongodb
ENV DEBIAN_FRONTEND noninteractive
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 && \
    echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list
RUN apt-get update && apt-get install -y --no-install-recommends openssl libcurl3 mongodb-org
VOLUME ["/data/db"]

# Technique to rebuild the docker file from here : https://stackoverflow.com/a/49831094/1228937
# Build using date > marker && docker build .
# date > marker && sudo docker build -t opendatacam .
COPY marker /dev/null
RUN git clone --depth 1 https://github.com/opendatacam/opendatacam /var/local/opendatacam

WORKDIR /var/local/opendatacam
RUN sed -i -e s+/darknet+/var/local/darknet+ config.json
RUN sed -i -e s+TO_REPLACE_VIDEO_INPUT+file+ config.json
RUN sed -i -e s+TO_REPLACE_NEURAL_NETWORK+yolov3+ config.json

# Build
RUN npm install
RUN npm run build

EXPOSE 8080 8070 8090 27017

RUN wget https://raw.githubusercontent.com/opendatacam/opendatacam/v2/docker/run-jetson/docker-start-mongo-and-opendatacam.sh
RUN chmod 777 docker-start-mongo-and-opendatacam.sh
CMD ./docker-start-mongo-and-opendatacam.sh
