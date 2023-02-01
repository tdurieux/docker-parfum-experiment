# Matterport3DSimulator
# Requires nvidia gpu with driver 384.xx or higher


FROM nvidia/cudagl:9.0-devel-ubuntu16.04

# Install a few libraries to support both EGL and OSMESA options
# ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y python-software-properties software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt-get install --no-install-recommends -y python3.6 && rm -rf /var/lib/apt/lists/*;
# switch python version
RUN rm /usr/bin/python
RUN rm /usr/bin/python3
RUN ln -s /usr/bin/python3.6 /usr/bin/python3
RUN ln -s /usr/bin/python3.6 /usr/bin/python
#
RUN apt-get install --no-install-recommends -y wget doxygen curl libjsoncpp-dev libepoxy-dev libglm-dev libosmesa6 libosmesa6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libglew-dev libopencv-dev python-opencv python3-setuptools python3.6-dev python3-pip python3.6-tk && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel
RUN pip3 install --no-cache-dir backports.functools-lru-cache==1.4 cycler==0.10.0 decorator==4.1.2 matplotlib==2.1.0 networkx==2.0
RUN pip3 install --no-cache-dir numpy==1.18.2 olefile pandas==0.21.0 Pillow >=4.3.0 pyparsing==2.2.0 python-dateutil==2.6.1
RUN pip3 install --no-cache-dir pytz==2017.3 pyyaml >=4.2b1 six==1.11.0 scipy==1.2.1 nltk scikit-image
RUN pip3 install --no-cache-dir opencv-python Cython easydict tensorboardX cffi h5py


# find suitable whl file at https://download.pytorch.org/whl/cu90/torch_stable.html
RUN wget https://download.pytorch.org/whl/cu90/torch-0.4.0-cp36-cp36m-linux_x86_64.whl
RUN pip3 install --no-cache-dir ./torch-0.4.0-cp36-cp36m-linux_x86_64.whl
RUN pip3 install --no-cache-dir torchvision==0.1.8
RUN rm ./torch-0.4.0-cp36-cp36m-linux_x86_64.whl

#install latest cmake
ADD https://cmake.org/files/v3.12/cmake-3.12.2-Linux-x86_64.sh /cmake-3.12.2-Linux-x86_64.sh
RUN mkdir /opt/cmake
RUN sh /cmake-3.12.2-Linux-x86_64.sh --prefix=/opt/cmake --skip-license
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
RUN cmake --version

ENV PYTHONPATH=/root/mount/Matterport3DSimulator/build
