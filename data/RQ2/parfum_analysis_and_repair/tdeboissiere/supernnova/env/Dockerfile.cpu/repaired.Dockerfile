FROM ubuntu:16.04

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
WORKDIR /home
RUN curl -f -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /home/miniconda3 && \
     rm ~/miniconda.sh && \
    /home/miniconda3/bin/conda update -y conda && \
    /home/miniconda3/bin/conda install -y pytorch-cpu torchvision-cpu -c pytorch && \
    /home/miniconda3/bin/conda config --add channels conda-forge && \
    /home/miniconda3/bin/conda install -y \
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
     unidecode && \
    /home/miniconda3/bin/conda clean -ya && \
    /home/miniconda3/bin/pip install sphinx sphinx-autobuild sphinxcontrib-napoleon sphinx_rtd_theme && \
    rm -Rf /home/miniconda3/pkgs && \
    cd /home/miniconda3 && find . -name '*.pyc' -delete && \
    cd /home/miniconda3/lib && \
    find . -name 'libmkl*avx512*' -delete && \
    find . -name 'libmkl*avx.so' -delete && \
    find . -name 'libmkl*mc*' -type f -delete

# Extra python packages
RUN /home/miniconda3/bin/pip install seaborn pytest-sugar pytest-cov sphinx-argparse tabulate

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
RUN sed -i 's/???/Docker???/g' /home/.oh-my-zsh/themes/refined.zsh-theme


ENTRYPOINT ["/bin/zsh"]
