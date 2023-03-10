#
# About: Test image for YOLOv2 object detection.
#
# MARK : This image contains a full development environment for Tensorflow with
# Intel optimization for fast inference and training on CPU. The image size is
# too large, it should be reduced in the future versions.
#

FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
        software-properties-common \
        net-tools iputils-ping iproute2 telnet sudo git wget python3-pip zip \
        libsm6 libxext6 libfontconfig1 libxrender1 libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
RUN git clone https://github.com/zrbzrb1106/yolov2.git

RUN wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O ~/anaconda.sh && \
        /bin/bash ~/anaconda.sh -b -p /opt/conda && \
        rm ~/anaconda.sh

# Use the Tensorflow with Intel optimization: tf_mkl
RUN /opt/conda/bin/conda env create -f /app/yolov2/dockerfiles/environment.yml && rm -rf /opt/conda/pkgs
RUN echo "source activate tf_mkl" > ~/.bashrc
ENV PATH /opt/conda/envs/tf_mkl/bin:$PATH
ENV CONDA_DEFAULT_ENV tf_mkl
RUN conda install numpy=1.15.0
# Avod encoding problem for Python3
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN useradd -ms /bin/bash yolov2
RUN adduser yolov2 sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /app/yolov2
RUN git pull origin master
# Download YOLOv2 model file (about 200MB)
RUN wget https://www.dropbox.com/s/xe8dyebmebomw42/yolo.pb?dl=0 -O ./model/yolo.pb
RUN git clone https://github.com/philferriere/cocoapi.git && \
    wget https://images.cocodataset.org/annotations/annotations_trainval2017.zip && \
    unzip ./annotations_trainval2017.zip -d ./cocoapi/ && \
    rm ./annotations_trainval2017.zip ./cocoapi/annotations/instances_train2017.json ./cocoapi/annotations/person_keypoints_train2017.json

COPY ./preprocessor.py /app/yolov2/preprocessor.py
COPY ./server.py /app/yolov2/server.py
COPY ./vnf.py /app/yolov2/vnf.py
COPY ./pedestrain.jpg /app/yolov2/pedestrain.jpg
RUN chown yolov2:yolov2 /app/yolov2/*.py
RUN chmod 700 /app/yolov2/*.py

# Try to reduce image size
RUN rm -rf /var/lib/apt/lists/* && \
    conda clean -y --all && \
    rm -rf /opt/conda/pkgs/*

USER root

CMD ["bash"]
