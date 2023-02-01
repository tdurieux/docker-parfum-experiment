FROM lithopscloud/ibmcf-python-v36

RUN apt-get update && apt-get install --no-install-recommends -y \
        wget build-essential cmake pkg-config \
        && rm -rf /var/lib/apt/lists/* \
        && apt-cache search linux-headers-generic

RUN pip install --no-cache-dir opencv-contrib-python-headless opencv-python-headless dlib \
    && wget https://github.com/cmusatyalab/openface/archive/0.2.1.tar.gz \
    && tar -zxvf 0.2.1.tar.gz && cd openface-0.2.1/ && python setup.py install && rm 0.2.1.tar.gz
