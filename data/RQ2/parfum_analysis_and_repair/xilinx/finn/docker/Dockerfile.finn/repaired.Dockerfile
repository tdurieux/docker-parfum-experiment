# Copyright (c) 2021, Xilinx
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of FINN nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

FROM pytorch/pytorch:1.7.1-cuda11.0-cudnn8-runtime
LABEL maintainer="Yaman Umuroglu <yamanu@xilinx.com>"

# XRT version to be installed
ARG XRT_DEB_VERSION="xrt_202010.2.7.766_18.04-amd64-xrt"

WORKDIR /workspace

# some Vitis deps require a timezone to be specified, which hangs in Docker
# use workaround from https://grigorkh.medium.com/fix-tzdata-hangs-docker-image-build-cdb52cc3360d
ENV TZ="Europe/Dublin"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libglib2.0-0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsm6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxext6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxrender-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y verilator && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zsh && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sshpass && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# install XRT
RUN wget https://www.xilinx.com/bin/public/openDownload?filename=$XRT_DEB_VERSION.deb -O /tmp/$XRT_DEB_VERSION.deb
RUN apt install --no-install-recommends -y /tmp/$XRT_DEB_VERSION.deb && rm -rf /var/lib/apt/lists/*;
RUN rm /tmp/$XRT_DEB_VERSION.deb

# versioned Python package requirements for FINN compiler
# these are given in requirements.txt
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN rm requirements.txt
# extra Python package dependencies (for testing and interaction)
RUN pip install --no-cache-dir pygments==2.4.1
RUN pip install --no-cache-dir ipykernel==5.5.5
RUN pip install --no-cache-dir jupyter==1.0.0
RUN pip install --no-cache-dir matplotlib==3.3.1 --ignore-installed
RUN pip install --no-cache-dir pytest-dependency==0.5.1
RUN pip install --no-cache-dir sphinx==3.1.2
RUN pip install --no-cache-dir sphinx_rtd_theme==0.5.0
RUN pip install --no-cache-dir pytest-xdist==2.0.0
RUN pip install --no-cache-dir pytest-parallel==0.1.0
RUN pip install --no-cache-dir "netron>=5.0.0"
RUN pip install --no-cache-dir pandas==1.1.5
RUN pip install --no-cache-dir scikit-learn==0.24.1
RUN pip install --no-cache-dir tqdm==4.31.1
RUN pip install --no-cache-dir -e git+https://github.com/fbcotter/dataset_loading.git@0.0.4#egg=dataset_loading

# git-based Python repo dependencies
# these are installed in editable mode for easier co-development
ARG FINN_BASE_COMMIT="e8facdd719b55839cca46da2cc4f4a4a372afb41"
ARG QONNX_COMMIT="9f9eff95227cc57aadc6eafcbd44b7acda89f067"
ARG FINN_EXP_COMMIT="af6102769226b82b639f243dc36f065340991513"
ARG BREVITAS_COMMIT="a5b71d6de1389d3e7db898fef72e014842670f03"
ARG PYVERILATOR_COMMIT="0c3eb9343500fc1352a02c020a736c8c2db47e8e"
ARG CNPY_COMMIT="4e8810b1a8637695171ed346ce68f6984e585ef4"
ARG HLSLIB_COMMIT="966d17d3fddd801927b2167627d23a9a15ed1461"
ARG OMX_COMMIT="1dfc4aa2f2895632742cd5751520c6b472feb74e"
ARG AVNET_BDF_COMMIT="2d49cfc25766f07792c0b314489f21fe916b639b"

# finn-base
RUN git clone https://github.com/Xilinx/finn-base.git /workspace/finn-base
RUN git -C /workspace/finn-base checkout $FINN_BASE_COMMIT
RUN pip install --no-cache-dir -e /workspace/finn-base
# Install qonnx without dependencies, currently its only dependency is finn-base
RUN git clone https://github.com/fastmachinelearning/qonnx.git /workspace/qonnx
RUN git -C /workspace/qonnx checkout $QONNX_COMMIT
RUN pip install --no-cache-dir --no-dependencies -e /workspace/qonnx
# finn-experimental
RUN git clone https://github.com/Xilinx/finn-experimental.git /workspace/finn-experimental
RUN git -C /workspace/finn-experimental checkout $FINN_EXP_COMMIT
RUN pip install --no-cache-dir -e /workspace/finn-experimental
# brevitas
RUN git clone https://github.com/Xilinx/brevitas.git /workspace/brevitas
RUN git -C /workspace/brevitas checkout $BREVITAS_COMMIT
RUN pip install --no-cache-dir -e /workspace/brevitas
# pyverilator
RUN git clone https://github.com/maltanar/pyverilator.git /workspace/pyverilator
RUN git -C /workspace/pyverilator checkout $PYVERILATOR_COMMIT
RUN pip install --no-cache-dir -e /workspace/pyverilator
# other git-based dependencies (non-Python)
# cnpy
RUN git clone https://github.com/rogersce/cnpy.git /workspace/cnpy
RUN git -C /workspace/cnpy checkout $CNPY_COMMIT
# finn-hlslib
RUN git clone https://github.com/Xilinx/finn-hlslib.git /workspace/finn-hlslib
RUN git -C /workspace/finn-hlslib checkout $HLSLIB_COMMIT
# oh-my-xilinx
RUN git clone https://bitbucket.org/maltanar/oh-my-xilinx.git /workspace/oh-my-xilinx
RUN git -C /workspace/oh-my-xilinx checkout $OMX_COMMIT
# board files
RUN cd /tmp; \
    wget -q https://github.com/cathalmccabe/pynq-z1_board_files/raw/master/pynq-z1.zip; \
    wget -q https://dpoauwgwqsy2x.cloudfront.net/Download/pynq-z2.zip; \
    unzip -q pynq-z1.zip; \
    unzip -q pynq-z2.zip; \
    mkdir /workspace/board_files; \
    mv pynq-z1/ /workspace/board_files/; \
    mv pynq-z2/ /workspace/board_files/; \
    rm pynq-z1.zip; \
    rm pynq-z2.zip; \
    git clone https://github.com/Avnet/bdf.git /workspace/avnet-bdf; \
    git -C /workspace/avnet-bdf checkout  $AVNET_BDF_COMMIT; \
    mv /workspace/avnet-bdf/* /workspace/board_files/;


# extra environment variables for FINN compiler
ENV VIVADO_IP_CACHE "/tmp/vivado_ip_cache"
ENV PATH "${PATH}:/workspace/oh-my-xilinx"
ENV OHMYXILINX "/workspace/oh-my-xilinx"

WORKDIR /workspace/finn

COPY docker/finn_entrypoint.sh /usr/local/bin/
COPY docker/quicktest.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/finn_entrypoint.sh
RUN chmod 755 /usr/local/bin/quicktest.sh
ENTRYPOINT ["finn_entrypoint.sh"]
CMD ["bash"]
