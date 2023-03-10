#
# Copyright (c) 2022, NVIDIA CORPORATION. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
FROM nvidia/cuda:11.4.3-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
# Disable NVIDIA repos to prevent accidental upgrades.
RUN cd /etc/apt/sources.list.d && \
    mv cuda.list cuda.list.disabled

# See https://github.com/databricks/containers/blob/master/ubuntu/minimal/Dockerfile
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
      openjdk-8-jdk \
      openjdk-8-jre \
      lsb-release \
      iproute2 \
      bash \
      sudo \
      coreutils \
      procps \
      wget && \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure && \
    rm -rf /var/lib/apt/lists/*


ENV PATH /databricks/conda/bin:$PATH

RUN wget -q https://repo.continuum.io/miniconda/Miniconda3-py38_4.9.2-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /databricks/conda && \
    rm miniconda.sh && \
    # Source conda.sh for all login and interactive shells.
    ln -s /databricks/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /etc/profile.d/conda.sh" >> ~/.bashrc && \
    # Set always_yes for non-interactive shells.
    conda config --system --set always_yes True && \
    conda clean --all

# install openjdk8, cmake, openmpi openmpi-mpicc
RUN conda install cmake openmpi openmpi-mpicc -y
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV PATH $PATH:/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre/bin:/usr/lib/jvm/java-1.8.0-openjdk-amd64/bin

RUN conda install -y -c nvidia -c rapidsai -c numba -c conda-forge nvtabular=1.2.2 python=3.8 cudatoolkit=11.4 scikit-learn

RUN pip uninstall tensorflow -y; pip install --no-cache-dir tensorflow-gpu==2.8
RUN pip install --no-cache-dir torch==1.11.0+cu115 torchvision==0.12.0+cu115 torchaudio===0.11.0+cu115 -f https://download.pytorch.org/whl/cu115/torch_stable.html
RUN rm -rf /databricks/conda/include/google
RUN HOROVOD_WITH_MPI=1 HOROVOD_GPU_OPERATIONS=NCCL HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 \
    pip install horovod[spark] --no-cache-dir
RUN pip install --no-cache-dir pynvml jupyter matplotlib


RUN apt-get update && apt-get install wget openssh-client openssh-server \
    -y --allow-downgrades --allow-change-held-packages --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN useradd --create-home --shell /bin/bash --groups sudo ubuntu

ENV PYSPARK_PYTHON=/databricks/conda/bin/python
ENV USER root
ENV DEFAULT_DATABRICKS_ROOT_CONDA_ENV=base
ENV DATABRICKS_ROOT_CONDA_ENV=base
# disable gds due to errors
ENV LIBCUDF_CUFILE_POLICY=OFF
# required by DB
RUN pip install --no-cache-dir virtualenv
RUN pip install --no-cache-dir adlfs
