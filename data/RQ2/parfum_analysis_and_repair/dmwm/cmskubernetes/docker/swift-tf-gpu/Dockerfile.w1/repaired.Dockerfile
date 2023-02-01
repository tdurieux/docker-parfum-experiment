FROM nvidia/cuda:11.1-devel-ubuntu18.04
MAINTAINER Valentin Kuznetsov vkuznet@gmail.com
RUN apt-get update
# configure tzinfo non-interactively
# https://techoverflow.net/2019/05/18/how-to-fix-configuring-tzdata-interactive-input-when-building-docker-images/
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl git libtinfo5 libncurses5 clang-10 libxml2 python libpython3.8 libpython2.7 sudo vim python3-numpy python3-matplotlib python3-pip wget && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir --upgrade tensorflow-gpu && pip3 install --no-cache-dir torch torchvision
ENV VER=swift-tensorflow-RELEASE-0.12-cuda11.0-cudnn8-ubuntu18.04
# ENV VER=swift-tensorflow-RELEASE-0.12-cuda10.1-cudnn7-ubuntu18.04
ENV WDIR=/
WORKDIR $WDIR
RUN curl -f -ksLO https://storage.googleapis.com/swift-tensorflow-artifacts/releases/v0.12/rc2/${VER}.tar.gz
RUN tar xfz ${VER}.tar.gz && rm ${VER}.tar.gz
ENV WDIR=/data
ENV USER=swift
ENV PYTHON_LIBRARY=/usr/lib/python3.8/config-3.8-x86_64-linux-gnu/libpython3.8.so
WORKDIR $WDIR
RUN git clone https://github.com/lgiommi/swift-models.git && cd swift-models && git checkout -b tensorflow-0.11 3bd96d22cca19b1024540815089ac908474df567
RUN git clone https://github.com/lgiommi/Swift4TFBenchmarks.git
ADD params.json /data/Swift4TFBenchmarks/models/MNIST/params.json
ADD run.sh /data/Swift4TFBenchmarks/models/MNIST/run.sh
# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin && mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600 && wget https://developer.download.nvidia.com/compute/cuda/11.2.0/local_installers/cuda-repo-ubuntu1804-11-2-local_11.2.0-460.27.04-1_amd64.deb && wget https://developer.download.nvidia.com/compute/cuda/11.2.0/local_installers/cuda_11.2.0_460.27.04_linux.run
# RUN dpkg -i cuda-repo-ubuntu1804-11-2-local_11.2.0-460.27.04-1_amd64.deb && apt-key add /var/cuda-repo-ubuntu1804-11-2-local/7fa2af80.pub && DEBIAN_FRONTEND=noninteractive apt-get update
# RUN DEBIAN_FRONTEND=noninteractive apt-get -y install cuda
RUN cd /data/Swift4TFBenchmarks/models/MNIST/SwiftML && swift build --configuration release
# RUN apt-get install -y nvidia-cuda-toolkit nvidia-cuda-toolkit-gcc
# RUN apt-get install -y lsb-release distro-info-data wget apt-utils
# RUN LAMBDA_REPO=$(mktemp) && wget -O${LAMBDA_REPO} https://lambdal.com/static/files/lambda-stack-repo.deb && dpkg -i ${LAMBDA_REPO} && rm -f ${LAMBDA_REPO} && apt-get update
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y lambda-stack-cuda
# RUN cd /tmp && apt-get download cudnn-license
# RUN RET=2 dpkg -i /tmp/cudnn-license_8.0.4-0lambda1_all.deb
#ENV LD_LIBRARY_PATH=/usr/local/cuda-11.0/compat/
#RUN ./benchmark.sh -p params.json
#RUN git clone https://github.com/vkuznet/SwiftMLExample.git
