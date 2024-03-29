#
# Copyright (c) 2021 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM ubuntu:20.04
RUN apt update && apt install --no-install-recommends -y build-essential curl && rm -rf /var/lib/apt/lists/*;
ARG OPENCV_DOWNLOAD_FOLDER
RUN curl -f -s ${OPENCV_DOWNLOAD_FOLDER}/openvino_opencv_ubuntu20.tgz | tar -xzf -
ARG NODE_NAME=image_transformation

ARG OPS="-fpic -O2 -U_FORTIFY_SOURCE -fstack-protector -fno-omit-frame-pointer -D_FORTIFY_SOURCE=1 -fno-strict-overflow -Wall -Wno-unknown-pragmas -Werror -Wno-error=sign-compare -fno-delete-null-pointer-checks -fwrapv"

COPY ./common /custom_nodes/common
COPY . /custom_nodes/${NODE_NAME}/
COPY custom_node_interface.h /
WORKDIR /custom_nodes/${NODE_NAME}/
RUN mkdir -p /custom_nodes/lib
RUN g++ -c -std=c++17 ${NODE_NAME}.cpp ${OPS} -I/extras/opencv/include/
RUN g++ -shared ${OPS} -o /custom_nodes/lib/libcustom_node_${NODE_NAME}.so ${NODE_NAME}.o \
    -L/extras/opencv/lib/ -I/extras/opencv/include/ -lopencv_core -lopencv_imgproc -lopencv_imgcodecs
