FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04
MAINTAINER Datmo devs <dev@datmo.io>

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         ca-certificates \
         libjpeg-dev \
         libpng-dev &&\
     rm -rf /var/lib/apt/lists/*

RUN curl -f -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda install conda-build && \
     /opt/conda/bin/conda create -y --name pytorch-py35 python=3.5.2 numpy scipy ipython mkl && \
     /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/envs/pytorch-py35/bin:$PATH
RUN conda install --name pytorch-py35 -c soumith magma-cuda80
# This must be done before pip so that requirements.txt is available
WORKDIR /opt/
RUN git clone https://github.com/pytorch/pytorch.git
WORKDIR /opt/pytorch

RUN cat requirements.txt | xargs -n1 pip install --no-cache-dir && \
    TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1+PTX" TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_LIBRARY_PATH=/opt/conda/envs/pytorch-py35/lib \
    CMAKE_INCLUDE_PATH=/opt/conda/envs/pytorch-py35/include \
    pip --no-cache-dir \


    install -v .

# Install other useful Python packages using pip
RUN apt-get update
RUN pip install --no-cache-dir --upgrade ipython && \
        pip install --no-cache-dir \
                ipykernel \
                jupyter \
                && \
        python -m ipykernel.kernelspec

#Jupyter notebook related configs
COPY jupyter_notebook_config.py /root/.jupyter/
EXPOSE 8888

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
COPY run_jupyter.sh /home/

#Adding flask
RUN pip install --no-cache-dir flask
EXPOSE 5000

WORKDIR /workspace
RUN chmod -R a+w /workspace
