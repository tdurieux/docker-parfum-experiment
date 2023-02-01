FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive

# Add cmake repository: https://apt.kitware.com/
RUN apt-get update -y \
 && apt-get install --no-install-recommends -y apt-transport-https ca-certificates gnupg software-properties-common wget \
 && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --batch --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null \
 && apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' && rm -rf /var/lib/apt/lists/*;

# Install other dependencies
RUN apt-get update -y && apt-get install --no-install-recommends -y build-essential git libomp-dev git cmake python3 python3-pip libboost1.71-all-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir tensorflow-gpu==2.4 numpy==1.19.2

RUN apt-get autoclean && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install semantic-meshes
RUN git clone https://github.com/fferflo/semantic-meshes
RUN mkdir /semantic-meshes/build
WORKDIR /semantic-meshes/build
RUN cmake -DCLASSES_NUMS=19 -DBUILD_PYTHON_INTERFACE=ON ..
RUN make && make install
RUN pip3 install --no-cache-dir ./python
