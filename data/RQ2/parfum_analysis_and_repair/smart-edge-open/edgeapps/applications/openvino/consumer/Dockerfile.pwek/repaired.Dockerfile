# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM ubuntu:20.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy,eaa.openness,analytics.openness
ENV DEBIAN_FRONTEND=noninteractive

##  OnPrem NTS uses CPU 0,2 and 3.
##  So OpenVINO user needs to configure the value according the setup
ENV OPENVINO_TASKSET_CPU=75

ARG OPENVINO_LINK=https://registrationcenter-download.intel.com/akdlm/irc_nas/17062/l_openvino_toolkit_p_2021.1.110.tgz
ARG YEAR=2021
ARG OPENVINO_DEMOS_DIR=/opt/intel/openvino_$YEAR/deployment_tools/open_model_zoo/demos
ARG MODEL_ROOT=/opt/intel/openvino_$YEAR/deployment_tools/open_model_zoo/tools/downloader
ARG NGINX_VERSION=1.21.1
ARG NGINX_RTMP_MODULE_VERSION=1.2.2
ENV APP_DIR=/opt/intel/openvino_$YEAR/deployment_tools/inference_engine/demos/python_demos/object_detection_demo_ssd_async/

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y
RUN apt install --no-install-recommends -y curl \
	unzip \
	python3-pip \
	git && rm -rf /var/lib/apt/lists/*;

RUN apt clean all

# OpenVino installation
RUN cd /tmp && \
	curl -f -O -L $OPENVINO_LINK && \
	tar xf l_openvino_toolkit*.tgz && \
	cd l_openvino_toolkit* && \
	sed -i 's/decline/accept/g' silent.cfg && \
	./install_openvino_dependencies.sh && \
	./install.sh -s silent.cfg && \
	rm -rf /tmp/l_openvino_toolkit* && rm l_openvino_toolkit*.tgz

# Install numpy
RUN pip3 install --no-cache-dir numpy

# Rebuilding libusb without UDEV support -- required for Intel Movidius Stick
RUN cd /tmp && \
	curl -f -O -L https://github.com/libusb/libusb/archive/v1.0.22.zip && \
	unzip v1.0.22.zip && cd libusb-1.0.22 && \
	./bootstrap.sh && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-udev --enable-shared && \
	make -j4 && make install && \
	rm -rf /tmp/*1.0.22*

# Build Nginx
# Install dependencies
RUN apt-get update && \
	apt-get install --no-install-recommends -y \
	ca-certificates \
	openssl libssl-dev yasm \
	libpcre3-dev librtmp-dev libtheora-dev \
	libvorbis-dev libvpx-dev libfreetype6-dev \
	libmp3lame-dev libx264-dev libx265-dev && \
	rm -rf /var/lib/apt/lists/*

# Download nginx source
RUN mkdir -p /tmp/build && \
	cd /tmp/build && \
	curl -f -O -L https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
	tar -zxf nginx-${NGINX_VERSION}.tar.gz && \
	rm nginx-${NGINX_VERSION}.tar.gz

# Download rtmp-module source
RUN cd /tmp/build && \
    curl -f -O -L https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    tar -zxf v${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
	rm v${NGINX_RTMP_MODULE_VERSION}.tar.gz

# Build nginx with nginx-rtmp module
RUN cd /tmp/build/nginx-${NGINX_VERSION} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --sbin-path=/usr/local/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx/nginx.pid \
        --lock-path=/var/lock/nginx.lock \
        --http-client-body-temp-path=/tmp/nginx-client-body \
        --with-http_ssl_module \
        --with-threads \
        --add-module=/tmp/build/nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION} && \
    make -j 2 && \
    make install

COPY nginx.conf /etc/nginx/nginx.conf
RUN chmod +s /usr/local/sbin/nginx

# Creating user openvino and adding it to groups "video" and "users" to use GPU and VPU
RUN useradd -ms /bin/bash -G video,users,www-data openvino && \
    chown -R openvino /home/openvino

COPY cmd/ /home/openvino
ADD start.sh.pwek /home/openvino/start.sh

RUN chown -R openvino:openvino /opt/intel/openvino*
RUN chown -R openvino:openvino /home/openvino/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log

USER openvino
RUN echo "source /opt/intel/openvino_$YEAR/bin/setupvars.sh" >> ~/.bashrc
RUN bash -c "source ~/.bashrc"

# Build OpenVINO samples
ADD object_detection_demo_ssd_async.patch $APP_DIR
RUN cd $APP_DIR && patch -p0 object_detection_demo_ssd_async.py object_detection_demo_ssd_async.patch

# Download OpenVINO pre-trained models
RUN cd $MODEL_ROOT && python3 -mpip install --user -r ./requirements.in && \
	./downloader.py --name pedestrian-detection-adas-0002 && \
	./downloader.py --name vehicle-detection-adas-0002

RUN cp -r $MODEL_ROOT/intel/vehicle-detection-adas-0002 $APP_DIR/ && \
    cp -r $MODEL_ROOT/intel/pedestrian-detection-adas-0002 $APP_DIR/

# Install Go
RUN cd /tmp && \
	curl -f -O -L https://dl.google.com/go/go1.15.linux-amd64.tar.gz && \
	tar -xvf go1.15.linux-amd64.tar.gz && rm go1.15.linux-amd64.tar.gz

ENV OPENVINO_ROOT=/opt/intel/openvino_$YEAR
ENV GOPATH=/home/openvino/go
ENV GOROOT=/tmp/go
ENV GO111MODULE=on
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
RUN mkdir $GOPATH

# Work Dir
WORKDIR /home/openvino
ADD output_320x240.mp4 ./

# Get go dependencies
RUN git config --global http.proxy $http_proxy
RUN go get github.com/gorilla/websocket
RUN go build main.go openvino.go eaa_interface.go

# OpenVINO inference and forwarding
ENTRYPOINT ["./start.sh"]
