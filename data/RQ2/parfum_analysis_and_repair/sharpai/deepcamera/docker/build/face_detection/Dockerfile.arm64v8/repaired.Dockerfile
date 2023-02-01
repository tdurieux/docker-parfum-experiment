FROM shareai/tensorflow:nano_latest
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install --no-install-recommends  -y python python-pip python-opencv python-dev \
    zlib1g-dev gcc python-pil && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y git scons cmake wget unzip curl build-essential \
    libprotobuf-dev protobuf-compiler libopencv-dev python-pip python-setuptools python-dev && rm -rf /var/lib/apt/lists/*;

ADD face_detector /root/detector
RUN cd /root/detector/3rdparty/ncnn && mkdir build && cd build && \
    cmake ../ && make -j6
RUN cp /root/detector/3rdparty/ncnn/build/src/libncnn.a /root/detector/lib/ncnn/libncnn.a

WORKDIR /root/detector/
RUN python setup.py install
RUN python ./test.py
ADD requirements.txt /root/requirements.txt
RUN pip install --no-cache-dir -r /root/requirements.txt
RUN pip install --no-cache-dir --upgrade numpy==1.15

RUN pip install --no-cache-dir pycuda==2019.1
RUN pip install --no-cache-dir onnx==1.4.1