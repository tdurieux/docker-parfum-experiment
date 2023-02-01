FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu16.04

RUN apt-get update -y
RUN apt install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt update -y
RUN apt-get install --no-install-recommends python3.7 -y && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 0
RUN apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends redis-server -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade setuptools pip
RUN apt-get install --no-install-recommends libsm6 libxext6 libxrender1 libglib2.0-0 ffmpeg -y && rm -rf /var/lib/apt/lists/*;
