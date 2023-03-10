# ngraph-neon.cpu dockerfile used to build and test ngraph-neon on gpu platforms

FROM nvidia/cuda:8.0-cudnn7-devel-ubuntu16.04

# try to get around issue with badsig
#https://github.com/NVIDIA/nvidia-docker/issues/619 (with devel image) (based on this issue added this)
RUN rm /etc/apt/sources.list.d/cuda.list

# removing nvidia-ml.list file to avoid apt-get update error
# "The method driver /usr/lib/apt/methods/https could not be found."
RUN rm /etc/apt/sources.list.d/nvidia-ml.list

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo curl apt-transport-https && \
    apt-get clean autoclean && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://developer.download.nvidia.com/compute/cuda/repos/GPGKEY | sudo apt-key add -

# install standard python 2 and 3 environment stuff
RUN apt-get update && \
    apt-get install --no-install-recommends -y python-dev python-pip software-properties-common && \
    apt-get clean autoclean && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir virtualenv==16.7.10 pytest

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip python3-dev python3-venv && \
    apt-get clean autoclean && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir virtualenv pytest

#install onnx dependencies to install ngraph
RUN apt-get update && apt-get install --no-install-recommends -y protobuf-compiler libprotobuf-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
        build-essential cmake \
        clang-3.9 clang-format-3.9 \
        git \
        wget patch diffutils zlib1g-dev libtinfo-dev \
        doxygen graphviz && \
        apt-get clean autoclean && \
        apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

# create a symbolic link for gmake command
RUN ln -s /usr/bin/make /usr/bin/gmake

# need to use sphinx version 1.6 to build docs
# installing with apt-get install python-sphinx installs sphinx version 1.3.6 only
# added install for python-pip above and
# installed sphinx with pip to get the updated version 1.6.5
# allows for make html build under the doc/source directory as an interim build process
RUN pip install --no-cache-dir sphinx

# breathe package required to build documentation
RUN pip install --no-cache-dir breathe

# need numpy to successfully build docs for python_api
RUN pip install --no-cache-dir numpy

# RUN python3 -m pip install m2r

WORKDIR /home
