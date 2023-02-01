FROM docker.io/ubuntu:hirsute

# update aptitude
ENV TZ=Europe/Zurich
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y --fix-missing upgrade

# install aptitude essentials
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install rsync && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gdb && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libgsl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-numpy && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-matplotlib && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-scipy && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-xlrd && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pandas && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libdnnl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libopenmpi-dev && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install meson
RUN python3 -m pip install ninja
RUN python3 -m pip install cmake
RUN python3 -m pip install pybind11

WORKDIR /home/ubuntu
RUN git clone https://github.com/cselab/korali.git
RUN cd korali; CC=gcc CXX=g++ meson setup build --prefix=/usr/local --buildtype=release -Donednn=true -Dmpi=true
RUN cd korali; ninja -C build
RUN cd korali; meson install -C build
ENV PYTHONPATH=/usr/local/lib/python3.9/site-packages/:$PYTHONPATH
