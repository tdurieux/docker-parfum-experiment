from ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        git \
        python3-pip \
        python3-setuptools \
        python3-opencv \
        python3-numpy \
        python3-scipy \ 
        python3-skimage \
        python3-sklearn \
        python3-dev \
        build-essential \
        libglib2.0-0 && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir opencv-python
RUN pip3 install --no-cache-dir keras==2.2.4
RUN pip3 install --no-cache-dir tensorflow==1.13.1

RUN cd /opt && \
    git clone https://github.com/eubr-atmosphere/radiomics.git
COPY video_classification.py /opt/radiomics/video_classification.py