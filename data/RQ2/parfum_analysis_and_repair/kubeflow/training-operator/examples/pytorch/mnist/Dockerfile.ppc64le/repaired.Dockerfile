FROM ppc64le/ubuntu:18.04
WORKDIR /root/
RUN apt-get update && apt-get -y --no-install-recommends install gcc g++ libjpeg-dev zlib1g-dev cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3 python3-pip git && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir numpy pyyaml
RUN git clone --recursive https://github.com/pytorch/pytorch && cd pytorch && python3 setup.py install
RUN pip3 install --no-cache-dir torchvision tensorboardX==1.6.0
WORKDIR /var
ADD mnist.py /var

ENTRYPOINT ["python3", "/var/mnist.py"]
