# FROM nvidia/cuda:10.1-cudnn7-devel
FROM nvidia/cuda:11.1.1-cudnn8-devel

LABEL Author="Zumo Labs <info@zumolabs.ai>"
LABEL Title="Docker for Package Sim case study."

# Environment variables
ENV ZPY_VERSION "1.4.1rc5"
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

# Data directory
ENV DATA "/data"

# Install basic python dev tools
RUN apt-get clean
RUN apt-get -y update && apt-get install --no-install-recommends -y \
	python3-opencv ca-certificates python3-dev git wget sudo \
	cmake ninja-build protobuf-compiler libprotobuf-dev && \
  rm -rf /var/lib/apt/lists/*
RUN ln -sv /usr/bin/python3 /usr/bin/python

# gcc and git are needed to install stuff below
RUN apt-get update && apt-get -y --no-install-recommends install gcc git && rm -rf /var/lib/apt/lists/*;

# Set up Pip
RUN wget https://bootstrap.pypa.io/get-pip.py && \
	python3 get-pip.py && rm get-pip.py

# Tensorflow
RUN pip install --no-cache-dir tensorboard

# Pytorch
RUN pip install --no-cache-dir --user torch==1.9 torchvision==0.10 -f https://download.pytorch.org/whl/cu111/torch_stable.html
RUN pip install --no-cache-dir --user 'git+https://github.com/facebookresearch/fvcore'

# Install Detectron2
RUN git clone https://github.com/facebookresearch/detectron2 detectron2_repo
# set FORCE_CUDA because during `docker build` cuda is not accessible
ENV FORCE_CUDA="1"
# This will by default build detectron2 for all common cuda architectures and take a lot more time,
# because inside `docker build`, there is no way to tell which architecture will be used.
ARG TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"
ENV TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST}"
RUN pip install --no-cache-dir --user -e detectron2_repo

# Install pycocotools directly from github
RUN pip install --no-cache-dir -U 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'

# Set a fixed model cache directory.
ENV FVCORE_CACHE="/tmp"
WORKDIR /home

# Install zpy (Zumo Labs Python)
RUN pip install --no-cache-dir scikit-image==0.18.1
RUN pip install --no-cache-dir zpy-zumo==${ZPY_VERSION}

# Extra pip dependencies
RUN pip install --no-cache-dir wandb
RUN pip install --no-cache-dir cython
RUN pip install --no-cache-dir lxml
RUN pip install --no-cache-dir gin-config
RUN pip install --no-cache-dir shapely
RUN pip install --no-cache-dir scikit-learn
RUN pip install --no-cache-dir opencv-python
RUN pip install --no-cache-dir tqdm
RUN pip install --no-cache-dir pyzmq
RUN pip3 install --no-cache-dir jupyter

# Copy over code
COPY . package
WORKDIR /home/package

# Connect and run jupyter Notebook
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]



