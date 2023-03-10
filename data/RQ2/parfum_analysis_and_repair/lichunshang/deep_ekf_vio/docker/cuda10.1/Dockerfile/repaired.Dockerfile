# SET BASE IMAGE:
# Typically offered by whatever primary library/environment you wish to develop against.
FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends python3 python3-pip git tzdata -y && rm -rf /var/lib/apt/lists/*;

# Install python packages within container
ENV PYTHON_PACKAGES="\
    matplotlib==3.0.3 \
    torch \
    torchvision \
    tensorboardX \
    transformations \
    scipy \
    numpy==1.16.0 \
    pandas \
    prettytable \
    evo \
"
RUN pip3 install --no-cache-dir cython
RUN pip3 install --no-cache-dir $PYTHON_PACKAGES

RUN mkdir -p /home/cs4li/Dev/deep_ekf_vio
RUN mkdir -p /home/cs4li/Dev/EUROC
RUN mkdir -p /home/cs4li/Dev/KITTI
