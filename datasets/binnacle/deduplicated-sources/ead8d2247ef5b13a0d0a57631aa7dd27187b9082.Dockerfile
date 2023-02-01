FROM ubuntu:16.04


##############################################################################
# common
##############################################################################
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential=12.1ubuntu2 \
        cmake=3.5.1-1ubuntu3 \
        git=1:2.7.4-0ubuntu1.4 \
        curl=7.47.0-1ubuntu2.8 \
        nano=2.5.3-2ubuntu2 \
        ca-certificates=20170717~16.04.1 \
        libjpeg-dev=8c-2ubuntu8 \
        libpng-dev \
        software-properties-common=0.96.20.7 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log


##############################################################################
# Miniconda & python 3.6
##############################################################################
RUN curl -sSL https://repo.continuum.io/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3.6.5 \
    && conda clean --all --yes

ENV PATH /opt/conda/bin:$PATH


##############################################################################
# sly dependencies
##############################################################################
# libgeos for shapely; other are deps of cv2
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libgeos-dev=3.5.0-1ubuntu2 \
        libsm6=2:1.2.2-1 \
        libxext6=2:1.3.3-1 \
        libxrender-dev=1:0.9.9-0ubuntu1 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# opencv; other packages are deps & mentioned to fix versions
RUN conda install -y -c menpo \
        opencv=3.4.1 \
        numpy=1.14.3 \
        zlib=1.2.11 \
        requests=2.18.4 \
    && conda clean --all --yes

RUN pip install --no-cache-dir \
        python-json-logger==0.1.8 \
        pybase64==0.4.0 \
        shapely==1.5.13 \
        imgaug==0.2.5 \
        opencv-python==3.4.1.15 \
        scipy==1.1.0 \
        scikit-image==0.13.0 \
        matplotlib==2.2.2 \
        pillow==5.1.0 \
        networkx==2.1 \
        jsonschema==2.6.0


##############################################################################
# Java to run Pycharm
##############################################################################
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        default-jre=2:1.8-56ubuntu2 \
        default-jdk=2:1.8-56ubuntu2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && ln -s /usr/lib/jvm/java-7-openjdk-amd64 /jre

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
