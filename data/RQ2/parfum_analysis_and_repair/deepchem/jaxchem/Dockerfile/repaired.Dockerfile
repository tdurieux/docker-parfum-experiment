FROM nvidia/cuda:10.1-cudnn7-devel

# Install some utilities
RUN apt-get update && \
    apt-get install --no-install-recommends -y -q wget git vim libxrender1 libsm6 bzip2 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install miniconda
RUN MINICONDA="Miniconda3-latest-Linux-x86_64.sh" && \
    wget --quiet https://repo.continuum.io/miniconda/$MINICONDA && \
    bash $MINICONDA -b -p /miniconda && \
    rm -f $MINICONDA && \
    echo ". /miniconda/etc/profile.d/conda.sh" >> ~/.bashrc
ENV PATH /miniconda/bin:$PATH

# install dependencies
RUN conda update -n base conda && \
    conda create -y -n jaxchem python=3.6 && \
    . /miniconda/etc/profile.d/conda.sh && \
    conda activate jaxchem && \
    PYTHON_VERSION=cp36 && \
    CUDA_VERSION=cuda101 && \
    PLATFORM=linux_x86_64 && \
    BASE_URL='https://storage.googleapis.com/jax-releases' && \
    pip install --no-cache-dir --upgrade $BASE_URL/$CUDA_VERSION/jaxlib-0.1.47-$PYTHON_VERSION-none-$PLATFORM.whl && \
    pip install --no-cache-dir --upgrade jax==0.1.69 && \
    pip install --no-cache-dir git+https://github.com/deepchem/jaxchem && \
    pip install --no-cache-dir tensorflow==2.2 && \
    pip install --no-cache-dir --pre deepchem && \
    conda install -y -c conda-forge rdkit && \
    conda clean -afy && \
    rm -rf ~/.cache/pip

RUN echo "conda activate jaxchem" >> ~/.bashrc
WORKDIR /root/mydir
