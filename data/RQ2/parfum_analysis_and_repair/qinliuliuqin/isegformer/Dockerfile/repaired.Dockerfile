FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
	    git \
	    curl \
        libglib2.0-0 \
        software-properties-common \
        python3.6-dev \
        python3-pip \
        python3-tk \
        firefox \
        libcanberra-gtk-module \
        nano && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir setuptools
RUN pip3 install --no-cache-dir matplotlib numpy pandas scipy tqdm pyyaml easydict scikit-image bridson Pillow ninja
RUN pip3 install --no-cache-dir imgaug mxboard graphviz
RUN pip3 install --no-cache-dir albumentations --no-deps
RUN pip3 install --no-cache-dir opencv-python-headless
RUN pip3 install --no-cache-dir Cython
RUN pip3 install --no-cache-dir torch
RUN pip3 install --no-cache-dir torchvision
RUN pip3 install --no-cache-dir scikit-learn
RUN pip3 install --no-cache-dir tensorboard

RUN mkdir /work
WORKDIR /work
RUN chmod -R 777 /work && chmod -R 777 /root

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
