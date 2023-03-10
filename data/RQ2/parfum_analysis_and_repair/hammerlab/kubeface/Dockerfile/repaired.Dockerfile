FROM nvidia/cuda:cudnn-runtime

MAINTAINER Tim O'Donnell <timodonnell@gmail.com>

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get clean && \
    apt-get update && \
    apt-get install --no-install-recommends --yes \
        gfortran \
        git \
        libatlas-base-dev \
        libatlas3gf-base \
        libblas-dev \
        libfreetype6-dev \
        libhdf5-serial-dev \
        liblapack-dev \
        libpng12-dev \
        libxml2-dev \
        libxslt1-dev \
        libyaml-dev \
        libzmq3-dev \
        pkg-config \
        python-virtualenv \
        python3-dev \
        python-dev && \
    apt-get clean && \
    useradd --create-home --home-dir /home/user --shell /bin/bash -G sudo user && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && rm -rf /var/lib/apt/lists/*;

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

USER user
ENV HOME=/home/user
ENV SHELL=/bin/bash
ENV USER=user
WORKDIR /home/user

# Setup virtual envs and install convenience packages.  Note: installing
RUN virtualenv venv-py3 --python=python3 && \
    venv-py3/bin/pip install --upgrade pip && \
    venv-py3/bin/pip install --upgrade \
        numpy \
        bokeh \
        cherrypy \
        jupyter \
        lxml \
        scipy \
        scikit-learn \
        dill \
        seaborn

ENV PATH /home/user/venv-py3/bin:$PATH
COPY . ./kubeface
RUN venv-py3/bin/pip install ./kubeface

