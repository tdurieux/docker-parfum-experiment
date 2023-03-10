ARG IMAGE
FROM ${IMAGE}
ARG PYTHON_VERSION

ARG DEBIAN_FRONTEND=noninteractive

COPY update_sources.sh /
RUN /update_sources.sh

RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture arm64

RUN echo 'deb [arch=arm64,armhf] http://ports.ubuntu.com/ bionic main restricted universe multiverse' >> /etc/apt/sources.list.d/armhf.list
RUN echo 'deb [arch=arm64,armhf] http://ports.ubuntu.com/ bionic-updates main restricted universe multiverse' >> /etc/apt/sources.list.d/armhf.list
RUN echo 'deb [arch=arm64,armhf] http://ports.ubuntu.com/ bionic-security main restricted universe multiverse' >> /etc/apt/sources.list.d/armhf.list
RUN echo 'deb [arch=arm64,armhf] http://ports.ubuntu.com/ bionic-backports main restricted universe multiverse' >> /etc/apt/sources.list.d/armhf.list
RUN sed -i 's#deb http://archive.ubuntu.com/ubuntu/#deb [arch=amd64] http://archive.ubuntu.com/ubuntu/#g' /etc/apt/sources.list


RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      software-properties-common \
      debhelper \
      crossbuild-essential-armhf \
      crossbuild-essential-arm64 \
      zlib1g-dev \
      zlib1g-dev:armhf \
      zlib1g-dev:arm64 \
      curl \
      unzip \
      git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN yes | add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      python$PYTHON_VERSION \
      python$PYTHON_VERSION-dev \
      python$PYTHON_VERSION-distutils \
      libpython$PYTHON_VERSION-dev \
      libpython$PYTHON_VERSION-dev:armhf \
      libpython$PYTHON_VERSION-dev:arm64 && rm -rf /var/lib/apt/lists/*;

RUN ln -sf /usr/bin/python$PYTHON_VERSION /usr/bin/python3
RUN curl -f -OL https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py
RUN rm get-pip.py
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir numpy~=1.19.2 setuptools pybind11
RUN ln -sf /usr/include/python$PYTHON_VERSION /usr/include/python3
RUN ln -sf /usr/local/lib/python$PYTHON_VERSION/dist-packages/numpy/core/include/numpy /usr/include/python3/numpy
RUN curl -f -OL https://github.com/Kitware/CMake/releases/download/v3.16.8/cmake-3.16.8-Linux-x86_64.sh
RUN mkdir /opt/cmake
RUN sh cmake-3.16.8-Linux-x86_64.sh --prefix=/opt/cmake --skip-license
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
