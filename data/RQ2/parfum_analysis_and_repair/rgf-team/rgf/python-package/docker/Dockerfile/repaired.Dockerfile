FROM ubuntu:16.04

# apt dependency
RUN apt-get update && \
    apt-get install --no-install-recommends -y cmake build-essential gcc g++ git wget && \
    
# python-package
    # miniconda \
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linu -x \
    /bin/bash Miniconda3-latest-Linux- 86 \
    export PATH="/opt/conda/bin:$PATH" && \
    # rgf_python \
    conda install -y -q numpy joblib scipy scikit le \
    git clone https://git ub com/RGF-team/rgf.git && \
        cd rgf/python-package && python setup.py install && \

ean \
    apt-get autoremove -y & && rm -rf /var/lib/apt/lists/*;

ENV PATH /opt/conda/bin:$PATH
