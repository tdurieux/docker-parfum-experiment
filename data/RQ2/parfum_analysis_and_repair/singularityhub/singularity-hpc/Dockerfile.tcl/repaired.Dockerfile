FROM ubuntu:20.04

# build a container with tcl modules for singularity-hpc
# docker build -f Dockerfile.tcl -t singularity-hpc .

LABEL MAINTAINER @vsoch
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential \
    gcc \
    tcl-dev \
    autoconf \
    automake \
    python3 \
    python3-sphinx \
    python3-dev \
    python3-pip \
    curl \
    less \
    wget && rm -rf /var/lib/apt/lists/*;

RUN wget -O- https://neuro.debian.net/lists/xenial.us-ca.full | tee /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9 && \
    apt-get update && \
    apt-get install --no-install-recommends -y singularity-container && rm -rf /var/lib/apt/lists/*;

RUN curl -f -LJO https://github.com/cea-hpc/modules/releases/download/v4.7.0/modules-4.7.0.tar.gz && \
    tar xfz modules-4.7.0.tar.gz && \
    cd modules-4.7.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && rm modules-4.7.0.tar.gz

RUN pip3 install --no-cache-dir ipython
WORKDIR /code
COPY . /code
RUN pip3 install --no-cache-dir -e .[all]

# If we don't run shpc through bash entrypoint, module commands not found
ENTRYPOINT ["/code/entrypoint.sh"]
