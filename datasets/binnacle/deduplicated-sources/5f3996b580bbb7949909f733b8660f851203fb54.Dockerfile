# ref: https://docs.microsoft.com/en-us/cognitive-toolkit/Setup-Linux-Python?tabs=cntkpy22#tabpanel_FweSSiKxOx_cntkpy22
# ref: https://github.com/Microsoft/CNTK/blob/master/Tools/docker/CNTK-CPUOnly-Image/Dockerfile
FROM lablup/kernel-python:3.6-ubuntu

ENV LANG=C.UTF-8
ENV PYTHONUNBUFFERED 1
ENV CNTK_VERSION="2.2"

RUN apt-get update && apt-get install -y wget bzip2
RUN apt-get update && apt-get install -y --no-install-recommends \
        autotools-dev \
        build-essential \
        cmake \
        git \
        g++-multilib \
        gcc-multilib \
        gfortran-multilib \
        libavcodec-dev \
        libavformat-dev \
        libjasper-dev \
        libjpeg-dev \
        libpng-dev \
        liblapacke-dev \
        libswscale-dev \
        libtiff-dev \
        pkg-config \
        wget \
        zlib1g-dev \
        # Protobuf
        ca-certificates \
        curl \
        vim-tiny \
        zip unzip \
        # # For Kaldi
        # python-dev \
        # automake \
        # libtool \
        # autoconf \
        # subversion \
        # # For Kaldi's dependencies
        # libapr1 libaprutil1 libltdl-dev libltdl7 libserf-1-1 libsigsegv2 libsvn1 m4 \
        # # For Java Bindings
        # openjdk-8-jdk \
        # For SWIG
        libpcre3-dev && \
    rm -rf /var/lib/apt/lists/*

# OpenMPI
RUN apt-get update && apt-get install -y openmpi-bin
ENV PATH /usr/local/mpi/bin:$PATH
ENV LD_LIBRARY_PATH /usr/lib/openmpi/lib:$LD_LIBRARY_PATH

# Anaconda
# RUN wget -q https://repo.continuum.io/archive/Anaconda3-4.3.1-Linux-x86_64.sh && \
#     sha256sum Anaconda3-4.3.1-Linux-x86_64.sh && \
#     bash Anaconda3-4.3.1-Linux-x86_64.sh -b && \
#     rm Anaconda3-4.3.1-Linux-x86_64.sh
# ENV PATH /root/anaconda3/bin:$PATH

# CNTK
RUN pip install --no-cache-dir https://cntk.ai/PythonWheel/CPU-Only/cntk-2.2-cp36-cp36m-linux_x86_64.whl
RUN python -c "import cntk; print(cntk.__version__)"

# Keras (set backend to use cntk)
RUN pip install --no-cache-dir keras
ENV KERAS_BACKEND=cntk

# Below scripts are already executed in python/Dockerfile.3.6-ubuntu
# Install kernel-runner scripts package
RUN pip install --no-cache-dir "backend.ai-kernel-runner[python]~=1.0.4"

COPY policy.yml /home/backend.ai/policy.yml

LABEL ai.backend.envs.corecount="OPENBLAS_NUM_THREADS,NPROC" \
      ai.backend.features="batch query uid-match user-input"

CMD ["/home/backend.ai/jail", "-policy", "/home/backend.ai/policy.yml", \
     "/usr/local/bin/python", "-m", "ai.backend.kernel", "python"]
