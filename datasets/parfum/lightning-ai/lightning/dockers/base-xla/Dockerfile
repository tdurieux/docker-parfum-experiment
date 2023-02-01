# Copyright The PyTorch Lightning team.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM google/cloud-sdk:slim

LABEL maintainer="Lightning-AI <https://github.com/Lightning-AI>"

# CALL: docker image build -t pytorch-lightning:XLA-image -f dockers/base-xla/Dockerfile . --build-arg PYTHON_VERSION=3.8
ARG PYTHON_VERSION=3.9
ARG CONDA_VERSION=4.9.2
ARG XLA_VERSION=1.11

SHELL ["/bin/bash", "-c"]
# for skipping configurations
ENV \
    DEBIAN_FRONTEND=noninteractive \
    CONDA_ENV=lightning

# show system info
RUN lsb_release -a && cat /etc/*-release

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        wget \
        curl \
        unzip \
        ca-certificates \
        libomp5 \
    && \
    # Install conda and python.
    # NOTE new Conda does not forward the exit status... https://github.com/conda/conda/issues/8385
    curl -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py39_${CONDA_VERSION}-Linux-x86_64.sh && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b && \
    rm ~/miniconda.sh && \
    # Cleaning
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /root/.cache && \
    rm -rf /var/lib/apt/lists/*

ENV \
    PATH="/root/miniconda3/bin:$PATH" \
    LD_LIBRARY_PATH="/root/miniconda3/lib:$LD_LIBRARY_PATH"
COPY environment.yml environment.yml

RUN conda create -y --name $CONDA_ENV && \
    conda init bash && \
    python -c "import re ; fname = 'environment.yml' ; req = re.sub(r'python>=[\d\.]+', 'python=${PYTHON_VERSION}', open(fname).read()) ; open(fname, 'w').write(req)" && \
    # drop unnecessary packages
    python -c "fname = 'environment.yml' ; req = open(fname).readlines() ; open(fname, 'w').writelines([ln for ln in req if not any(n in ln for n in ['pytorch>', 'horovod'])])" && \
    cat environment.yml && \
    conda env update --file environment.yml && \
    conda clean -ya && \
    rm environment.yml

ENV \
    PATH=/root/miniconda3/envs/${CONDA_ENV}/bin:$PATH \
    LD_LIBRARY_PATH="/root/miniconda3/envs/${CONDA_ENV}/lib:$LD_LIBRARY_PATH" \
    # if you want this environment to be the default one, uncomment the following line:
    CONDA_DEFAULT_ENV=${CONDA_ENV}

# Disable cache
RUN pip --version && \
    pip config set global.cache-dir false && \
    conda remove pytorch torchvision && \
    # Install Pytorch XLA
    py_version=${PYTHON_VERSION/./} && \
    gsutil cp "gs://tpu-pytorch/wheels/torch-${XLA_VERSION}-cp${py_version}-cp${py_version}m-linux_x86_64.whl" . && \
    gsutil cp "gs://tpu-pytorch/wheels/torch_xla-${XLA_VERSION}-cp${py_version}-cp${py_version}m-linux_x86_64.whl" . && \
    gsutil cp "gs://tpu-pytorch/wheels/torchvision-${XLA_VERSION}-cp${py_version}-cp${py_version}m-linux_x86_64.whl" . && \
    pip install *.whl && \
    rm *.whl

# Get package
COPY ./ ./pytorch-lightning/

RUN \
    python --version && \
    cd pytorch-lightning && \
    pip install -q fire && \
    # drop packages installed with XLA
    python .actions/assistant.py requirements_prune_pkgs torch,torchvision && \
    # drop unnecessary packages
    python ./requirements/pytorch/adjust-versions.py ./requirements/pytorch/extra.txt && \
    # install PL dependencies
    pip install --requirement ./requirements/pytorch/devel.txt --no-cache-dir && \
    cd .. && \
    rm -rf pytorch-lightning && \
    rm -rf /root/.cache

RUN \
    # Show what we have
    pip --version && \
    conda info && \
    pip list && \
    python -c "import sys; assert sys.version[:3] == '$PYTHON_VERSION', sys.version" && \
    python -c "import torch; assert torch.__version__.startswith('$XLA_VERSION'), torch.__version__"
