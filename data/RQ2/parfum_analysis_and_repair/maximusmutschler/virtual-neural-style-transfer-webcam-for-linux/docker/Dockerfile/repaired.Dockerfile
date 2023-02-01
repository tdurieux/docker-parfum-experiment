FROM nvcr.io/nvidia/tensorrt:21.05-py3

RUN apt-get update
WORKDIR /stylecam/

COPY ./src/ ./src/
COPY ./requirements.txt .
COPY ./akvcam_config/ ./akvcam_config/
RUN mkdir data
COPY ./docker/entryscript.sh .
RUN ["chmod", "+x", "./entryscript.sh"]
RUN touch /dev/video13


RUN apt update
RUN apt -y --no-install-recommends install dkms && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y tzdata && rm -rf /var/lib/apt/lists/*;

RUN apt update && \
    apt install -y --no-install-recommends \
      python3-numpy \
      python3-opencv \
      build-essential \
      && rm -rf /var/cache/apt/* /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir torch==1.8.1
RUN pip install --no-cache-dir opencv-python==4.5.1.48
RUN pip install --no-cache-dir torchvision==0.9.1
RUN pip install --no-cache-dir numpy==1.19.5
RUN pip install --no-cache-dir onnx==1.9.0


# adding ubuntu 18 ppa
RUN  echo "deb http://security.ubuntu.com/ubuntu bionic-security main" >> /etc/apt/sources.list
RUN apt update
RUN apt -y --no-install-recommends install linux-headers-$(uname -r) && rm -rf /var/lib/apt/lists/*;


RUN git clone https://github.com/webcamoid/akvcam.git
RUN cd akvcam/src && make
RUN cd akvcam/src && make dkms_install
RUN cd /stylecam/ && mkdir -p /etc/akvcam
RUN cp akvcam_config/* /etc/akvcam/

RUN pip uninstall pycuda --yes
RUN pip install --no-cache-dir pycuda==2021.1


