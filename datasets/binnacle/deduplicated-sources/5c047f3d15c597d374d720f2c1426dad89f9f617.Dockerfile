# Based on: https://github.com/ibm-functions/runtime-python/tree/master/python3.6

FROM ibmfunctions/action-python-v3.6:master

RUN apt-get update && apt-get install -y \
        wget build-essential cmake pkg-config \
        && rm -rf /var/lib/apt/lists/*

RUN apt-cache search linux-headers-generic

RUN pip install opencv-contrib-python-headless opencv-python-headless dlib
RUN wget https://github.com/cmusatyalab/openface/archive/0.2.1.tar.gz && tar -zxvf 0.2.1.tar.gz && cd openface-0.2.1/ && python setup.py install
