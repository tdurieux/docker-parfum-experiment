FROM nvidia/cuda:9.1-cudnn7-devel
# This is an Ubuntu 16.04 base image.
# TODO: Upgrade to 18.04. Need a machine with CUDA 9.2 to test.

## Python installation ##
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*

# Install Python 3.6 on Ubuntu 16.04 using deadsnakes ppa.
RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update &&  rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install --no-install-recommends -y git python3.6 python3.6-dev libgl1-mesa-glx curl wget && rm -rf /var/lib/apt/lists/*

# Install pip on Python 3.6
RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3.6
RUN python3.6 -m pip install --no-cache-dir --upgrade pip

# Make Python 3.6 default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 0
RUN update-alternatives --install /usr/bin/python3-config python3-config /usr/bin/python3.6-config 0
RUN update-alternatives --install /usr/bin/pip3 pip3 /usr/local/bin/pip3.6 0

## Install opencv-python. This is used by the demo script. ##
RUN pip3 install --no-cache-dir opencv-python

## Download and compile YOLO3-4-Py ##
WORKDIR /
RUN git clone https://github.com/madhawav/YOLO3-4-Py.git
WORKDIR /YOLO3-4-Py/src
RUN pip3 install --no-cache-dir cython>=0.29 requests>=2.25 numpy>=1.19
ENV GPU 1
RUN pip3 install --no-cache-dir .

## Run test ##
WORKDIR /YOLO3-4-Py/
RUN sh tools/download_models.sh
COPY ./docker_demo.py /YOLO3-4-Py/docker_demo.py
CMD ["python3", "docker_demo.py"]
