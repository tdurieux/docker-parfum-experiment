#######################################################################
# Dockerfile to build Kaldi (speech recognition engine container      #
# image - based on Ubuntu + SRILM                                     #
#######################################################################

FROM ubuntu:20.04

########################## BEGIN INSTALLATION #########################

ENV NUM_CPUS=6

ENV TZ=UTC

RUN export DEBIAN_FRONTEND="noninteractive" && apt-get update && apt-get install --no-install-recommends -y --fix-missing \
    autoconf \
    automake \
    bzip2 \
    curl \
    g++ \
    gcc \
    gfortran \
    git \
    glpk-utils \
    gsl-bin libgsl-dev \
    libatlas-base-dev \
    libglib2.0-dev \
    libjson-c-dev \
    libtool-bin \
    libssl-dev \
    libsqlite3-dev \
    libbz2-dev \
    liblzma-dev \
    lsof \
    lzma \
    make \
    nvtop \
    software-properties-common \
    subversion \
    tree \
    unzip \
    vim \
    wget \
    zlib1g-dev \
    zsh && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp

ENV LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PATH="/opt/pyenv/shims:/opt/pyenv/bin:$PATH" \
    PYENV_ROOT="/opt/pyenv" \
    PYENV_SHELL="zsh"

RUN echo "===> Install pyenv Python 3.8" && \
    git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT && \
    echo 'export PYENV_ROOT="/opt/pyenv"' >> ~/.zshrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc && \
    echo 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc && \
    eval "$(pyenv init -)" && \
    cat ~/.zshrc && \
    /bin/bash -c "source ~/.zshrc" && \
    pyenv install 3.8.2 && \
    rm -rf /tmp/*


########################## KALDI INSTALLATION #########################

RUN echo "===> Install Python 2.7 for Kaldi" && \
    add-apt-repository universe && \
    apt-get update && apt-get install --no-install-recommends -y \
    python2.7 \
    python-yaml \
    python-simplejson \
    python-gi && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && \
    python2.7 get-pip.py

RUN pip2.7 install ws4py==0.3.2 && \
    pip2.7 install tornado

RUN ln -s /usr/bin/python2.7 /usr/bin/python ; ln -s -f bash /bin/sh

RUN echo "===> Install Kaldi dependencies" && \
    apt-get update && apt-get install --no-install-recommends -y \
    sox \
    graphviz \
    ghostscript \
    ffmpeg && rm -rf /var/lib/apt/lists/*;

WORKDIR /

RUN echo "===> Install Kaldi (pinned at version 5.3)"  && \
    git clone -b 5.3 https://github.com/kaldi-asr/kaldi
COPY deps/pa_stable_v19_20111121.tgz /kaldi/tools/pa_stable_v19_20111121.tgz
RUN cd /kaldi/tools && make -j$NUM_CPUS && ./install_portaudio.sh
RUN cd /kaldi/src && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --mathlib=ATLAS --shared && \
    sed -i '/-g # -O0 -DKALDI_PARANOID/c\-O3 -DNDEBUG' kaldi.mk && \
    make depend -j$NUM_CPUS && make -j$NUM_CPUS
RUN cd /kaldi/src/online2 && make depend -j$NUM_CPUS && make -j$NUM_CPUS
RUN cd /kaldi/src/online2bin && make depend -j$NUM_CPUS && make -j$NUM_CPUS

COPY deps/srilm-1.7.2.tar.gz /kaldi/tools/srilm.tgz

WORKDIR /kaldi/tools

RUN apt-get install -y --no-install-recommends gawk && \
    chmod +x extras/* && \
    ./extras/install_liblbfgs.sh && \
    ./extras/install_srilm.sh && \
    chmod +x env.sh && \
    source ./env.sh && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libssl-dev libsqlite3-dev libbz2-dev && rm -rf /var/lib/apt/lists/*;


########################## DEV HELPERS INSTALLATION ####################

WORKDIR /tmp

RUN echo "===> Install dev helpers"

# Example data
RUN git clone --depth=1 https://github.com/CoEDL/toy-corpora.git

# Add jq
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
    chmod +x jq-linux64 && \
    mv jq-linux64 /usr/local/bin/jq

# Add node 15, yarn and xml-js
RUN curl -f -sL https://deb.nodesource.com/setup_15.x | bash - && apt-get update && apt-get install --no-install-recommends -y nodejs build-essential && \
    npm install -g npm \
    hash -d npm \
    npm install -g xml-js yarn && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Clean up package manager
RUN apt-get clean autoclean

WORKDIR /root

# ZSH
RUN apt-get install -y --no-install-recommends zsh && rm -rf /var/lib/apt/lists/*;
RUN chsh -s /usr/bin/zsh root
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)" -- -t robbyrussell -p history-substring-search -p git


########################## VENV ########################

WORKDIR /
RUN pyenv global 3.8.2
RUN python -m venv venv
RUN source venv/bin/activate
RUN pip install --no-cache-dir --upgrade pip


########################## HF Transformers INSTALLATION #########################

# Install deps using pip rather than poetry mainly because poetry doesn't have -f support for the +cu111 version details
# Override the dep info from requirements.txt so that we can specifiy CUDA version
# Pin transformers to 4.6.0 because the model class has args code which breaks on later versions
# Pin protobuf to fix `PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION` error
RUN pip install --no-cache-dir protobuf==3.20.*
RUN pip install --no-cache-dir transformers==4.6.0 datasets jiwer==2.2.0 lang-trans==0.6.0 librosa==0.8.0
# Set torch version for CUDA 11
RUN pip install --no-cache-dir torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install --no-cache-dir tensorboard==2.7.0

# Cache the pretrained models
COPY download_wav2vec2.py /root/download_wav2vec2.py
RUN python /root/download_wav2vec2.py


########################## ELPIS INSTALLATION ########################

# Add random number generator to skip Docker building from cache
ADD http://www.random.org/strings/?num=10&len=8&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new /uuid

WORKDIR /

RUN echo "===> Install Elpis"
# Remove `--single-branch` and replace with `--branch <your_branch_name>` below for development
RUN git clone --single-branch --depth=1 https://github.com/CoEDL/elpis.git

WORKDIR /elpis
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false && \
    poetry install

# Elpis GUI
WORKDIR /elpis/elpis/gui/
RUN yarn install && \
    yarn run build && yarn cache clean;

# Sample data for command line interaction with Elpis
WORKDIR /
RUN git clone --depth=1 https://github.com/CoEDL/toy-corpora.git
RUN git clone --depth=1 https://github.com/CoEDL/timit-elan.git
WORKDIR /datasets
RUN ln -s /toy-corpora/abui /datasets/abui
RUN ln -s /toy-corpora/na /datasets/na
RUN ln -s /timit-elan /datasets/timit

########################## RUN THE APP ##########################

# ENV vars for interactive running
RUN echo "export FLASK_ENV=development" >> ~/.zshrc
RUN echo "export FLASK_APP=elpis" >> ~/.zshrc
RUN echo "export LC_ALL=C.UTF-8" >> ~/.zshrc
RUN echo "export LANG=C.UTF-8" >> ~/.zshrc
WORKDIR /elpis
RUN echo "export POETRY_PATH=$(poetry env info -p)" >> ~/.zshrc
RUN echo "export PATH=$PATH:${POETRY_PATH}/bin:/kaldi/src/bin/" >> ~/.zshrc
RUN echo "alias run=\"poetry run flask run --host=0.0.0.0 --port=5001\"" >> ~/.zshrc
RUN cat ~/.zshrc >> ~/.bashrc

# ENV vars for non-interactive running
ENV FLASK_ENV='development'
ENV FLASK_APP='elpis'
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /elpis

ENTRYPOINT ["poetry", "run", "flask", "run", "--host", "0.0.0.0", "--port", "5001"]

# 5001 is for the Flask server
EXPOSE 5001
# 3000 is for the Webpack dev server
EXPOSE 3000
