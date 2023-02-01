FROM ubuntu:18.04

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

RUN sed -i s@/archive.ubuntu.com/@/mirrors.tencent.com/@g /etc/apt/sources.list
RUN sed -i s@/security.ubuntu.com/@/mirrors.tencent.com/@g /etc/apt/sources.list

RUN apt-get clean && apt-get update -y && apt-get -y install --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install git cmake make && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install gcc g++ && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install protobuf-compiler libprotobuf-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install python3 python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;

#RUN mkdir -p  /root/.pip && echo "[global]\n index-url = https://mirrors.tencent.com/pypi/simple/" >> /root/.pip/pip.conf

RUN python3 -m pip install --upgrade pip && pip3 install --no-cache-dir -U onnx==1.6.0 onnxruntime numpy onnx-simplifier setuptools protobuf


RUN pip3 install --no-cache-dir tensorflow==1.15.0 tf2onnx

ENV TNN_ROOT=/opt/TNN
ENV TOOLS_ROOT=$TNN_ROOT/tools
# COPY ./onnx2tnn $TOOLS_ROOT/onnx2tnn
# COPY ./caffe2onnx $TOOLS_ROOT/caffe2onnx
# COPY ./convert2tnn $TOOLS_ROOT/convert2tnn
COPY . $TNN_ROOT/
#RUN cd $TOOLS_ROOT/onnx2tnn/onnx-converter && ./build.sh
RUN cd $TOOLS_ROOT/convert2tnn && bash ./build.sh


RUN python3 $TOOLS_ROOT/convert2tnn/converter.py -h

WORKDIR $TOOLS_ROOT/convert2tnn/
