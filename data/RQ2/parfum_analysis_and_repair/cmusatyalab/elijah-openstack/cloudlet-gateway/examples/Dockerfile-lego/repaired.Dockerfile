FROM registry.cmusatyalab.org/junjuew/gabriel-container-registry:base
MAINTAINER Junjue Wang, junjuew@cs.cmu.edu

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    python-opencv \
    build-essential \
    cmake \
    libboost-all-dev \
    && apt-get autoremove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir dlib

RUN apt-get install --no-install-recommends -y \
    python-matplotlib \
    libblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    gfortran \
    && apt-get autoremove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir scikit-image

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    redis-tools \
    && apt-get autoremove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD gabriel-apps /gabriel-apps
ADD run.sh /run.sh

WORKDIR /

EXPOSE 9098 9101

CMD ["/run.sh"]