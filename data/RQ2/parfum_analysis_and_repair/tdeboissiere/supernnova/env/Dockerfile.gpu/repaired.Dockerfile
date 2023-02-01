FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

####################################
# Apt libraries
####################################
RUN apt-get update && apt-get install -y --no-install-recommends\
        build-essential \
        apt-utils \
        cmake \
        git \
        less \
        zsh \
        curl \
        vim \
        graphviz \
        libjpeg-dev \
        libpng-dev \
        gfortran \
        zlib1g-dev \
        automake \
        autoconf \
        git \
        libtool \
        subversion \
        libatlas3-base \
        ffmpeg \
        python-pip \
        python-dev \
        wget \
        libncurses5-dev \
        libncursesw5-dev \
        unzip \
        sox \
        locales &&\
     rm -rf /var/lib/apt/lists/*

WORKDIR /home
ENV HOME /home

###################################
# Anaconda + python deps
###################################
#  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
WORKDIR /home
RUN curl -f -o ~/miniconda.sh -O  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /home/miniconda3 && \
     rm ~/miniconda.sh

# RUN    /home/miniconda3/bin/conda install -c anaconda tensorflow-gpu
RUN    /home/miniconda3/bin/conda install -y pytorch==0.4.1 torchvision -c pytorch
RUN    /home/miniconda3/bin/pip install \
     h5py \
     matplotlib \
     colorama \
     tqdm \
     scipy \
     natsort \
     pandas \
     astropy \
     ipdb \
     scikit-learn \
     pytest \
     unidecode &&\
    /home/miniconda3/bin/pip install sphinx sphinx-autobuild sphinxcontrib-napoleon sphinx_rtd_theme tabulate

# Extra python packages
RUN /home/miniconda3/bin/pip install seaborn pytest-sugar pytest-cov mxnet-cu90

####################################
# Set up locale to avoid zsh errors
####################################
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen --purge --lang en_US \
    && locale-gen
ENV LANG en_US.utf8

####################################
# Set up oh my zsh
####################################
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
COPY zshrc ${HOME}/.zshrc
RUN sed -i 's/❯/Docker❯/g' /home/.oh-my-zsh/themes/refined.zsh-theme


ENTRYPOINT ["/bin/zsh"]
