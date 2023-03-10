# https://www.learnopencv.com/install-opencv3-on-ubuntu
# https://docs.opencv.org/3.4/d6/d15/tutorial_building_tegra_cuda.html

ARG CUDA_VERSION=10.1
ARG CUDNN_VERSION=7

FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel-ubuntu18.04

ARG PYTHON_VERSION=3.6
ARG OPENCV_VERSION=4.1.1

# Needed for string substitution
SHELL ["/bin/bash", "-c"]

# Add CUDA libs paths
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update && \
    CUDA_PATH=(/usr/local/cuda-*) && \
    CUDA=`basename $CUDA_PATH` && \
    echo "$CUDA_PATH/compat" >> /etc/ld.so.conf.d/${CUDA/./-}.conf && \
    ldconfig && \        
    # Install all dependencies for OpenCV and Caffe
    apt-get -y update --fix-missing && \
    apt-get -y install --no-install-recommends \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-dev \
    $( [ ${PYTHON_VERSION%%.*} -ge 3 ] && echo "python${PYTHON_VERSION%%.*}-distutils" ) \
    build-essential \
    wget \
    unzip \
    git \   
    python-scipy \
    python-skimage \
    libopencv-dev \    
    && \
# install python dependencies
    sysctl -w net.ipv4.ip_forward=1 && \
    wget https://bootstrap.pypa.io/get-pip.py --progress=bar:force:noscroll && \
    python${PYTHON_VERSION} get-pip.py && \
    rm get-pip.py && \
    pip${PYTHON_VERSION} install --no-cache-dir numpy && \
    pip${PYTHON_VERSION} install --no-cache-dir torch && \
    pip${PYTHON_VERSION} install --no-cache-dir torchvision && \
    pip${PYTHON_VERSION} install --no-cache-dir lmdb && \
    pip${PYTHON_VERSION} install --no-cache-dir six && \
    pip${PYTHON_VERSION} install --no-cache-dir matplotlib && \
    pip${PYTHON_VERSION} install --no-cache-dir tqdm && \
    pip${PYTHON_VERSION} install --no-cache-dir nni && \
    pip${PYTHON_VERSION} install --no-cache-dir progress && \
    pip${PYTHON_VERSION} install --no-cache-dir filetype && \
    pip${PYTHON_VERSION} install --no-cache-dir msgpack_python && \
    pip${PYTHON_VERSION} install --no-cache-dir Pillow && \
    pip${PYTHON_VERSION} install --no-cache-dir PyYAML && \
    pip${PYTHON_VERSION} install --no-cache-dir imgaug && \
    pip${PYTHON_VERSION} install --no-cache-dir tensorboard && \
# Set the default python and install PIP packages
    update-alternatives --install /usr/bin/python${PYTHON_VERSION%%.*} python${PYTHON_VERSION%%.*} /usr/bin/python${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1 && rm -rf /var/lib/apt/lists/*;

# connect 8080 for nni
EXPOSE 8080

ENV MobileNetYOLO_ROOT=/workspace/Mobilenet-YOLO-Pytorch
WORKDIR $MobileNetYOLO_ROOT

RUN cd /workspace && \
	git clone --depth 1 https://github.com/eric612/Mobilenet-YOLO-Pytorch.git  && \
	#unzip caffe.zip && \
	cd $MobileNetYOLO_ROOT