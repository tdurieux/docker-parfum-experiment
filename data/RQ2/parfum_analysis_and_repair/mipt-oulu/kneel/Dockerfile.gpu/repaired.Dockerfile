FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

MAINTAINER Aleksei Tiulpin, University of Oulu, Version 1.0

RUN apt-get update && apt-get upgrade -y
RUN apt-get -o Dpkg::Options::="--force-confmiss" -y --no-install-recommends install --reinstall netbase && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends curl locales ca-certificates libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*
RUN locale-gen --purge en_US.UTF-8 && echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

# Making sure that the locales are correctly installed
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8
# Installing conda
RUN curl -f -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN chmod +x ~/miniconda.sh && ~/miniconda.sh -b -p /opt/conda && rm ~/miniconda.sh
ENV PATH=/opt/conda/bin:${PATH}

# Installing the dependencies
RUN apt-get remove -y --auto-remove curl ca-certificates
RUN conda install -y pytorch=1.1.0 torchvision=0.3.0 -c pytorch
RUN conda install -y scikit-learn pandas tqdm termcolor sas7bdat matplotlib

RUN pip install --no-cache-dir opencv-python==4.1.1.26 pydicom==1.3.0 flask==1.1.1 gevent==1.4.0 solt >=0.1.5 mpmath==1.1.0
RUN pip install --no-cache-dir --no-deps deep-pipeline==0.2.5

RUN conda clean -afy \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete


# Setting up the package
RUN mkdir -p /opt/pkg/
COPY . /opt/pkg/
RUN pip install --no-cache-dir -e /opt/pkg/

# Copying the files
RUN cp  /opt/pkg/scripts/inference_new_data.py .
