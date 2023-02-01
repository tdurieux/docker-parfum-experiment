FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04
ARG PYTHON_VERSION=3.8

RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-dev python3-setuptools python3-pip \ 
      gcc clang llvm llvm-dev build-essential cmake \
      vim git curl tmux wget unzip \
      ca-certificates apt-utils \
      libtinfo-dev zlib1g-dev libjpeg-dev libpng-dev libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /Downloads
RUN curl -f -o ~/miniconda.sh \
      https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda install -y python=$PYTHON_VERSION pip && \
    /opt/conda/bin/conda install -y pytorch=1.6.0 torchvision=0.7.0 \
      cudatoolkit=10.2 -c pytorch && \
    /opt/conda/bin/conda install -y lmdb python-lmdb pandas matplotlib \
      psutil tqdm scipy && \
    /opt/conda/bin/conda clean -ya

ENV PATH /opt/conda/bin:$PATH

RUN pip install --no-cache-dir plyfile hyperopt

RUN git clone https://github.com/NVIDIA/PyProf.git && \
    cd PyProf && \
    python3 setup.py install && \
    cd ..

COPY third_party/nsys/nsys_cli_2020.3.1.72.deb nsys_cli.deb
RUN apt-get install -y --no-install-recommends ./nsys_cli.deb && rm -rf /var/lib/apt/lists/*;

COPY third_party/dcgm/datacenter-gpu-manager_2.0.10_amd64.deb dcgm.deb
RUN apt-get install -y --no-install-recommends ./dcgm.deb && rm -rf /var/lib/apt/lists/*;
