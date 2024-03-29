FROM shareai/tensorflow:nano_latest

RUN apt-get update && apt-get install --no-install-recommends -y autoconf automake libtool curl make g++ unzip git && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
RUN git clone https://github.com/tensorflow/models
RUN wget https://github.com/google/protobuf/releases/download/v3.5.1/protobuf-all-3.5.1.tar.gz
ENV PYTHONPATH /root/models/research/object_detection:/root/models/research:/root/models/research/slim
RUN tar -zxvf protobuf-all-3.5.1.tar.gz && rm protobuf-all-3.5.1.tar.gz
WORKDIR /root/protobuf-3.5.1
RUN ls -alh && \
       ./autogen.sh && \
       ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
       make && \
       make check && \
       make install && \
       ldconfig
WORKDIR /root/models/research
RUN protoc object_detection/protos/*.proto --python_out=.

WORKDIR /root
ADD ./assets/models/ssdlite_mobilenet_v2_coco_2018_05_09/frozen_inference_graph.pb /root/ssdlite_mobilenet_v2_coco_2018_05_09/frozen_inference_graph.pb
ADD ./assets/labelmap.prototxt /root/ssdlite_mobilenet_v2_coco_2018_05_09/

ADD ./assets/requirements.txt /root/
RUN pip install --no-cache-dir -r /root/requirements.txt
ADD od.py /root/
ADD panda.jpg /root/
WORKDIR /root
#clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /root/.cache/pip/
# RUN PYTHONPATH="/root/models/research/object_detection:/root/models/research:/root/models/research/slim" python od.py worker --loglevel INFO -E -n od -c 1 -Q od
