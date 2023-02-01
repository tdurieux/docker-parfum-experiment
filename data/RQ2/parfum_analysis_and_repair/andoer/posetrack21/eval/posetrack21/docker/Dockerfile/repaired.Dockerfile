FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV PATH /opt/miniconda3/bin:$PATH
ENV CPLUS_INCLUDE_PATH /opt/miniconda3/include

RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-file && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential \
    checkinstall \
    cmake \
    pkg-config \
    git \
    neovim tmux curl sudo && rm -rf /var/lib/apt/lists/*;

RUN curl -f -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3
RUN conda update -y -n base -c defaults conda
RUN conda install python==3.8.0

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt
