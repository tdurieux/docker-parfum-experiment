FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         unzip \
         curl \
         wget \
         vim \
         tmux \
         htop \
         less \
         locate \
         ca-certificates \
         libsm6 \
         libxext6 \
         libxrender1 &&\
         rm -rf /var/lib/apt/lists/*

RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh

ENV PATH=/opt/conda/bin:$PATH \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN pip install -U \
        tqdm \
        click \
        logzero \
        gensim \
        optuna \
        tensorboardX \
        scikit-image \
        lockfile \
        pytest \
        Cython \
        pyyaml \
        jupyter \
        jupyterthemes \
        kaggle \
        opencv-python \
        joblib \
        seaborn \
        pretrainedmodels \
        plotly \
        albumentations \
        line-profiler \
        tabulate \
        cloudpickle==0.5.6 # to suppress warning

RUN conda install -y pytorch torchvision cuda92 -c pytorch && \
    conda install -y pandas scikit-learn matplotlib pytables tensorflow-gpu keras && \
    conda install -c conda-forge jupyter_contrib_nbextensions
RUN conda clean --all

RUN jupyter contrib nbextension install --user
RUN jt -t grade3 -f firacode -nf firacode -altp -fs 100 -tfs 100 -nfs 100 -dfs 100 -ofs 100 -cellw 88% -T