FROM continuumio/anaconda3

RUN apt-get update && \
    apt-get install --no-install-recommends -y gfortran curl git wget bzip2 build-essential ninja-build g++ && rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/conda/bin/bin:${PATH} CONDA_PREFIX=/opt/conda

# NOTE:  1. MKL is installed with pytorch.
#           turbo-transformers will use the same MKL from PyTorch

RUN /opt/conda/bin/conda install pytorch==1.5.0 cpuonly -c pytorch && \
    pip install --no-cache-dir OpenNMT-py onnxruntime==1.4.0 && \
    /opt/conda/bin/conda install curl conda-verify conda-build mkl-include cmake -c anaconda && \
    /opt/conda/bin/conda install make cmake git graphviz gperftools git-lfs docopt -c conda-forge && \
    /opt/conda/bin/conda clean -afy

RUN pip --no-cache-dir install contexttimer future transformers==4.11.1 docopt onnxruntime-tools
WORKDIR /workspace
