FROM ubuntu:20.04
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH /tmp/openpilot:$PYTHONPATH

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    bzip2 \
    ca-certificates \
    capnproto \
    clang \
    curl \
    g++ \
    gcc-arm-none-eabi libnewlib-arm-none-eabi \
    git \
    libarchive-dev \
    libavformat-dev libavcodec-dev libavdevice-dev libavutil-dev libswscale-dev libavresample-dev libavfilter-dev \
    libbz2-dev \
    libcapnp-dev \
    libcurl4-openssl-dev \
    libffi-dev \
    libtool \
    libssl-dev \
    libsqlite3-dev \
    libusb-1.0-0 \
    libzmq3-dev \
    locales \
    opencl-headers \
    ocl-icd-opencl-dev \
    make \
    patch \
    pkg-config \
    python \
    python-dev \
    unzip \
    wget \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN curl -f -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:${PATH}"
ENV OPENPILOT_REF="1b0167ce24afb037b36464c40f9c5e0d657e77d9"
ENV OPENDBC_REF="b2895650c744e24d48cee2f13563dcd5b030a271"

COPY requirements.txt /tmp/
RUN pyenv install 3.8.10 && \
    pyenv global 3.8.10 && \
    pyenv rehash && \
    pip install --no-cache-dir -r /tmp/requirements.txt

RUN cd /tmp && \
    git clone https://github.com/danmar/cppcheck.git && \
    cd cppcheck && \
    git fetch && \
    git checkout e1cff1d1ef92f6a1c6962e0e4153b7353ccad04c && \
    FILESDIR=/usr/share/cppcheck make -j4 install

RUN cd /tmp && \
    git clone https://github.com/commaai/openpilot.git tmppilot || true && \
    cd /tmp/tmppilot && \
    git fetch && \
    git checkout $OPENPILOT_REF && \
    git submodule update --init cereal opendbc rednose_repo && \
    git -C opendbc fetch && \
    git -C opendbc checkout $OPENDBC_REF && \
    git -C opendbc reset --hard HEAD && \
    git -C opendbc clean -xfd && \
    mkdir /tmp/openpilot && \
    cp -pR SConstruct site_scons/ tools/ selfdrive/ system/ common/ cereal/ opendbc/ rednose/ third_party/ /tmp/openpilot && \
    rm -rf /tmp/tmppilot

RUN cd /tmp/openpilot && \
    pip install --no-cache-dir -r opendbc/requirements.txt && \
    pip install --no-cache-dir --upgrade aenum lru-dict pycurl tenacity atomicwrites serial smbus2 scons

COPY . /tmp/openpilot/panda
RUN rm -rf /tmp/openpilot/panda/.git
