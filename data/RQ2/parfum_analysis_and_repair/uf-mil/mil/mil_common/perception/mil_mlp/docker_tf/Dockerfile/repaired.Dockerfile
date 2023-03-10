# Copyright 2018 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# #==========================================================================

FROM tensorflow/tensorflow:latest-devel-gpu

# Get the tensorflow models research directory, and move it into tensorflow
# source folder to match recommendation of installation
RUN git clone --depth 1 https://github.com/tensorflow/models.git && \
    mv models /tensorflow/models


# Install gcloud and gsutil commands
# https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install --no-install-recommends google-cloud-sdk -y && rm -rf /var/lib/apt/lists/*;


# Install the Tensorflow Object Detection API from here
# https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/installation.md

# Install object detection api dependencies
RUN apt-get install --no-install-recommends -y protobuf-compiler python-pil python-lxml python-tk && \
    pip install --no-cache-dir Cython && \
    pip install --no-cache-dir contextlib2 && \
    pip install --no-cache-dir jupyter && \
    pip install --no-cache-dir matplotlib && rm -rf /var/lib/apt/lists/*;

# Install pycocoapi
RUN git clone --depth 1 https://github.com/cocodataset/cocoapi.git && \
    cd cocoapi/PythonAPI && \
    make -j8 && \
    cp -r pycocotools /tensorflow/models/research && \
    cd ../../ && \
    rm -rf cocoapi

# Get protoc 3.0.0, rather than the old version already in the container
RUN curl -f -OL "https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip" && \
    unzip protoc-3.0.0-linux-x86_64.zip -d proto3 && \
    mv proto3/bin/* /usr/local/bin && \
    mv proto3/include/* /usr/local/include && \
    rm -rf proto3 protoc-3.0.0-linux-x86_64.zip

# Run protoc on the object detection repo
RUN cd /tensorflow/models/research && \
    protoc object_detection/protos/*.proto --python_out=.

# Set the PYTHONPATH to finish installing the API
ENV PYTHONPATH $PYTHONPATH:/tensorflow/models/research:/tensorflow/models/research/slim


# Install wget (to make life easier below) and editors (to allow people to edit
# the files inside the container)
RUN apt-get install --no-install-recommends -y wget vim emacs nano && rm -rf /var/lib/apt/lists/*;


# Grab various data files which are used throughout the demo: dataset,
# pretrained model, and pretrained TensorFlow Lite model. Install these all in
# the same directories as recommended by the blog post.

# Pets example dataset
RUN mkdir -p /tmp/pet_faces_tfrecord/ && \
    cd /tmp/pet_faces_tfrecord && \
    curl -f "https://download.tensorflow.org/models/object_detection/pet_faces_tfrecord.tar.gz" | tar xzf -

# Pretrained model
# This one doesn't need its own directory, since it comes in a folder.
RUN cd /tmp && \
    curl -f -O "http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v1_0.75_depth_300x300_coco14_sync_2018_07_03.tar.gz" && \
    tar xzf ssd_mobilenet_v1_0.75_depth_300x300_coco14_sync_2018_07_03.tar.gz && \
    rm ssd_mobilenet_v1_0.75_depth_300x300_coco14_sync_2018_07_03.tar.gz

# Trained TensorFlow Lite model. This should get replaced by one generated from
# export_tflite_ssd_graph.py when that command is called.
RUN cd /tmp && \
    curl -f -L -o tflite.zip \
    https://storage.googleapis.com/download.tensorflow.org/models/tflite/frozengraphs_ssd_mobilenet_v1_0.75_quant_pets_2018_06_29.zip && \
    unzip tflite.zip -d tflite && \
    rm tflite.zip

# Configure the build to use the things we just downloaded
# RUN cd /tensorflow && \
#     printf '\n\nn\ny\nn\nn\nn\ny\nn\nn\nn\nn\nn\nn\n\ny\n%s\n\n\n' ${ANDROID_HOME}|./configure
RUN cd /tensorflow && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"

RUN pip install --no-cache-dir shapely requests

WORKDIR /tensorflow/models/research/object_detection

RUN mkdir transfer_learning && \
    apt-get install --no-install-recommends tmux -y && rm -rf /var/lib/apt/lists/*;
