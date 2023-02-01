ARG UBUNTU_VERSION=18.04

FROM ubuntu:${UBUNTU_VERSION} AS base
MAINTAINER Qian Qian (xeonqq@gmail.com)
ENV LANG C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3.7 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN ln -s $(which python3.7) /usr/local/bin/python3
RUN ln -s $(which python3.7) /usr/local/bin/python
RUN python3 -m pip --no-cache-dir install --upgrade \
    "pip<20.3" \
    setuptools
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      git \
      wget \
      openjdk-8-jdk \
      python3-dev \
      virtualenv \
      swig && rm -rf /var/lib/apt/lists/*;

RUN apt-get update
RUN apt-get install --no-install-recommends -y \
      ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libgl1-mesa-glx protobuf-compiler && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install --no-cache-dir matplotlib videoio opencv-python
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list
RUN curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update
RUN apt-get install --no-install-recommends -y libedgetpu1-std && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pycoral && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-tflite-runtime && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --no-cache-dir -r /tmp/requirements.txt
RUN python3 -m pip install --no-cache-dir opencv-contrib-python==4.4.0.46

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin
RUN apt-get install --no-install-recommends -y python3-tk && rm -rf /var/lib/apt/lists/*;


EXPOSE 5005
