FROM kaixhin/cuda-caffe:7.0
WORKDIR /root

# Install wget and python-dev
RUN apt-get install --no-install-recommends wget python-dev -y && rm -rf /var/lib/apt/lists/*;

# Install vim (for my sanity)
RUN apt-get install --no-install-recommends vim -y && rm -rf /var/lib/apt/lists/*;

# Install numpy for data analyis
RUN pip install --no-cache-dir numpy easydict

# Install Faster RCNN dependencies
RUN apt-get install --no-install-recommends cmake cython python-opencv -y && rm -rf /var/lib/apt/lists/*;

# Clone Faster RCNN
RUN apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
RUN git clone --recursive https://github.com/mbuckler/py-faster-rcnn.git

WORKDIR /root/py-faster-rcnn

# Build Faster RCNN
WORKDIR /root/py-faster-rcnn/lib
RUN make

WORKDIR /root/py-faster-rcnn/caffe-fast-rcnn
RUN mkdir build
WORKDIR /root/py-faster-rcnn/caffe-fast-rcnn/build
RUN cmake ..
RUN make -j4 && make pycaffe

# Remaining dependency
RUN apt-get install --no-install-recommends python-tk -y && rm -rf /var/lib/apt/lists/*;

# Solve the lib1394 issue
RUN ln /dev/null /dev/raw1394

WORKDIR /root/py-faster-rcnn/

# Get the model files
RUN ./data/scripts/fetch_faster_rcnn_models.sh
RUN ./data/scripts/fetch_imagenet_models.sh

# Make the directory for our data
RUN mkdir data/VOCdevkit2007
