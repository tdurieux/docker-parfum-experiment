FROM ubuntu:16.04
RUN apt-get update

## Pyton installation ##
RUN apt-get install --no-install-recommends -y python3.5 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

## OpenCV 3.4 Installation ##
RUN apt-get install --no-install-recommends -y build-essential cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qt5-default libvtk6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev python-tk python-numpy python3-dev python3-tk python3-numpy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/opencv/opencv/archive/3.4.0.zip
RUN unzip 3.4.0.zip
RUN rm 3.4.0.zip
WORKDIR /opencv-3.4.0
RUN mkdir build
WORKDIR /opencv-3.4.0/build
RUN cmake -DBUILD_EXAMPLES=OFF ..
RUN make -j4
RUN make install
RUN ldconfig

## Downloading and compiling darknet ##
WORKDIR /
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/pjreddie/darknet.git
WORKDIR /darknet
# Set OpenCV makefile flag
RUN sed -i '/OPENCV=0/c\OPENCV=1' Makefile
RUN make
ENV DARKNET_HOME /darknet
ENV LD_LIBRARY_PATH /darknet

## Download and compile YOLO3-4-Py ##
WORKDIR /
RUN git clone https://github.com/madhawav/YOLO3-4-Py.git
WORKDIR /YOLO3-4-Py
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir pkgconfig
RUN pip3 install --no-cache-dir cython
RUN pip3 install --no-cache-dir Flask
RUN pip3 install --no-cache-dir flask-cors
RUN pip3 install --no-cache-dir opencv-python
RUN pip3 install --no-cache-dir opencv-contrib-python
RUN pip3 install --no-cache-dir Pillow
RUN pip3 install --no-cache-dir redis
RUN python3 setup.py build_ext --inplace

ADD . /YOLO3-4-Py

## Run ##
CMD ["python3", "-u", "server.py"]