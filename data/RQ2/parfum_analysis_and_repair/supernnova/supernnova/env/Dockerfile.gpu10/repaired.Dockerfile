FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu16.04

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
RUN /home/miniconda3/bin/pip install seaborn pytest-sugar pytest-cov


ENV PATH=$PATH:/u/home/.local/bin

####################################
# Set up locale to avoid zsh errors
####################################
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen --purge --lang en_US \
    && locale-gen

################################################
# Set up the environment variables
# Used in installing following libs as well
################################################

ENV TMP_PATH=/u/home/dump \
    LD_LIBRARY_PATH="/usr/local/lib:/home/miniconda3/lib:$LD_LIBRARY_PATH" \
    PATH=/home/miniconda3/bin:$PATH \
    LANG=en_US.utf8 \
    USER=researcher \
    USER_ID=2018 \
    USER_GID=2018

#######################################
# Adding a user which will be mapped to
# real user running the docker
#######################################

RUN mkdir -p /u/home && \
    groupadd --gid "${USER_GID}" "$USER" && \
    useradd \
    --uid ${USER_ID} \
    --gid ${USER_GID} \
    --home-dir /u/home \
    --shell /usr/bin/zsh \
    ${USER}

####################################
# Set up oh my zsh
####################################
WORKDIR /u/home
COPY zshrc /u/home/.zshrc
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /u/home/.oh-my-zsh &&\
    sed -i 's/❯/Docker❯/g' /u/home/.oh-my-zsh/themes/refined.zsh-theme
# Path to your oh-my-zsh installation.
ENV ZSH=/u/home/.oh-my-zsh \
    PATH_TO_COPY=${PATH}

COPY entry_script.sh /
RUN chmod u+x /entry_script.sh
ENV HOME=/u/home

ENTRYPOINT ["/bin/bash", "/entry_script.sh"]
