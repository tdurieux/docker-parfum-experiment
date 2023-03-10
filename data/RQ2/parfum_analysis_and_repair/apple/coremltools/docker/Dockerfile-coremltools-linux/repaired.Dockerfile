# An Ubuntu based image that is used for gitlab based ci infrastructure
FROM ubuntu:18.04

# Install dependencies, particularly libraries that python or CMake need
RUN apt-get -y update \
     && apt-get -y --no-install-recommends install build-essential libstdc++6 \
        python-setuptools curl git libssl-dev \
        make vim-common zlib1g-dev libffi-dev \
        libbz2-dev libopenblas-dev liblapack-dev \
        zsh uuid-dev gobjc++ && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt-get -y --no-install-recommends install git-lfs && rm -rf /var/lib/apt/lists/*;

WORKDIR /
RUN  mkdir src
ENV PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:

# Install CMake
WORKDIR /opt
RUN curl -f -L https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4-Linux-x86_64.tar.gz -o cmake-3.13.4-Linux-x86_64.tar.gz \
     && tar xf cmake-3.13.4-Linux-x86_64.tar.gz && rm cmake-3.13.4-Linux-x86_64.tar.gz
ENV PATH=/opt/cmake-3.13.4-Linux-x86_64/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Install Anaconda and initialize it for use in ZSH
WORKDIR /opt
RUN curl -f https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh -o anaconda.sh
RUN zsh anaconda.sh -b -p /opt/anaconda && eval "$(/opt/anaconda/bin/conda shell.zsh hook)" && conda init zsh && conda init bash

# Give Cmake hints about compilers to use.
ENV CC="/usr/bin/gcc"
ENV CXX="/usr/bin/g++"
CMD ["/bin/bash"]

# Start at /root
WORKDIR /root
