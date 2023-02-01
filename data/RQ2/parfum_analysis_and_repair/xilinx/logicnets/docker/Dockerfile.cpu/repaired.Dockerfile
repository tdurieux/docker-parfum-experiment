#  Copyright (C) 2021 Xilinx, Inc
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

FROM ubuntu:18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

WORKDIR /workspace

ARG GID
ARG GNAME
ARG UNAME
ARG UID

# Install conda system prerequisites, commands based on: https://github.com/conda/conda-docker/blob/master/miniconda3/debian/Dockerfile
RUN apt-get -qq update && apt-get -qq --no-install-recommends -y install curl bzip2 \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# Install LogicNets system prerequisites
RUN apt-get -qq update && apt-get -qq --no-install-recommends -y install verilator build-essential libx11-6 git \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# Adding LogicNets dependency on OHMYXILINX
RUN git clone https://bitbucket.org/maltanar/oh-my-xilinx.git
ENV OHMYXILINX=/workspace/oh-my-xilinx

# Add Nitro-parts-library
RUN  git clone https://github.com/dirjud/Nitro-Parts-lib-Xilinx.git
ENV NITROPARTSLIB=/workspace/Nitro-Parts-lib-Xilinx

# Create the user account to run LogicNets
RUN groupadd -g $GID $GNAME
RUN useradd -m -u $UID $UNAME -g $GNAME
ENV UNAME_HOME=/home/$UNAME
USER $UNAME
ENV USER=$UNAME
ENV HOME=/home/$UNAME

# Install conda
ENV CONDA_ROOT=$HOME/.local/miniconda3
RUN mkdir -p $CONDA_ROOT
ENV PATH=$CONDA_ROOT/bin:$PATH
RUN curl -f -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp $CONDA_ROOT \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3 \
    && conda update -y conda \
    && conda clean --all --yes

# Install LogicNets prerequisites
RUN conda install -y pytorch==1.4.0 torchvision==0.5.0 cpuonly -c pytorch && \
    conda clean -ya
# Install Brevitas prerequisites
RUN conda install -y packaging pyparsing && \
    conda clean -ya
RUN conda install -y docrep -c conda-forge && \
    conda clean -ya
RUN pip install --no-cache-dir git+https://github.com/Xilinx/brevitas.git@67be9b58c1c63d3923cac430ade2552d0db67ba5
# Install prerequisites for pyverilator
RUN pip install --no-cache-dir pyverilator
# Install prerequisites for oh-my-xilinx
RUN conda install -y zsh -c conda-forge && \
    conda clean -ya

# Install LogicNets library - SKIP this step and install during entry-point
#RUN git clone git@github.com:Xilinx/logicnets.git && \
#    cd logicnets && \
#    pip install --upgrade .

# Install prerequisites for the JSC examples
RUN conda install -y wget && \
    conda clean -ya
RUN conda install -y h5py pyyaml numpy pandas scikit-learn tensorboard && \
    conda clean -ya

# Add entry point script to install LogicNets and setup vivado.
ENV LOCAL_PATH=$HOME/.local/bin
RUN mkdir -p $LOCAL_PATH
COPY docker/entry-point.sh $LOCAL_PATH
ENV PATH=$LOCAL_PATH:$PATH
ENTRYPOINT ["entry-point.sh"]
CMD ["bash"]
