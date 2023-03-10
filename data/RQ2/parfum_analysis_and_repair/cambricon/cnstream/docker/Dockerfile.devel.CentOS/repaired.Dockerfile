#/*************************************************************************
# * Copyright (C) [2021] by Cambricon, Inc. All rights reserved
# *
# *  Licensed under the Apache License, Version 2.0 (the "License");
# *  you may not use this file except in compliance with the License.
# *  You may obtain a copy of the License at
# *
# *     http://www.apache.org/licenses/LICENSE-2.0
# *
# * The above copyright notice and this permission notice shall be included in
# * all copies or substantial portions of the Software.
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# * THE SOFTWARE.
# *************************************************************************/

# 1. build image:
#  docker build -f Dockerfile.devel.CentOS -t cnstream:latest .
# 2. start container:
#  docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY --privileged -v /dev:/dev --net=host --ipc=host --pid=host -it --name container_name  -v $PWD:/workspace cnstream:latest

FROM centos:7.6.1810

RUN echo -e 'nameserver 8.8.8.8\nnameserver 114.114.114.114' > /etc/resolv.conf

RUN yum install -y wget unzip && \
    yum install -y epel-release curl libcurl-devel && \
    yum install -y zlib-devel git make vim gcc gcc-c++ kernel-devel net-tools mediainfo && \
    yum install -y gflags-devel glog-devel SDL2_gfx-devel librdkafka-devel lcov && \
    yum install -y freetype-devel wqy-zenhei-fonts  && \
    rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && \
    rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm && \
    yum install -y ffmpeg ffmpeg-devel gstreamer* && \
    yum install -y python3 python3-devel && \
    yum install -y python-pip && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    pip3 install --no-cache-dir virtualenv && \
    wget -c https://cmake.org/files/v3.10/cmake-3.10.2.tar.gz && \
    tar xvf cmake-3.10.2.tar.gz && \
    cd cmake-3.10.2; rm -rf /var/cache/yum rm cmake-3.10.2.tar.gz ./bootstrap --prefix=/usr; make -j $(($(nproc) + 1)); make install && \
    cd -; rm -r cmake*; cd ~ &&\
    wget -c https://github.com/opencv/opencv/archive/3.4.16.zip &&\
    unzip 3.4.16.zip; cd opencv-3.4.16; mkdir build; cd build &&\
    cmake -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_DOCS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DWITH_CUDA=OFF -DWITH_OPENCL=OFF -DWITH_V4L=OFF -DWITH_GTK=OFF .. &&\
    make -j $(($(nproc) + 1)); make install &&\
    cd ~; rm 3.4.16.zip; rm -rf opencv-3.4.16 && \
    sed -i '0,/python/s/python/python2/' /usr/bin/yum && \
    sed -i '0,/python/s/python/python2/' /usr/libexec/urlgrabber-ext-down &&\
    sed -i '0,/python/s/python/python2/' /usr/bin/yum-config-manager



