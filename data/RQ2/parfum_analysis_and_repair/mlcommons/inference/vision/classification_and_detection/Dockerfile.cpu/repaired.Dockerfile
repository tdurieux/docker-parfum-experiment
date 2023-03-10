FROM ubuntu:16.04

ENV PYTHON_VERSION=3.7
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PATH /opt/anaconda3/bin:$PATH

WORKDIR /root
ENV HOME /root

RUN apt-get update && apt-get install -y --no-install-recommends \
      git \
      build-essential \
      software-properties-common \
      ca-certificates \
      wget \
      curl \
      htop \
      zip \
      unzip && rm -rf /var/lib/apt/lists/*;

RUN cd /opt && \
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O miniconda.sh && \
    /bin/bash ./miniconda.sh -b -p /opt/anaconda3 && \
    rm miniconda.sh && \
    /opt/anaconda3/bin/conda clean -tipsy && \
    ln -s /opt/anaconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/anaconda3/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    conda config --set always_yes yes --set changeps1 no

RUN conda install pytorch-cpu torchvision-cpu -c pytorch
RUN pip install --no-cache-dir future pillow onnx opencv-python-headless tensorflow onnxruntime
RUN pip install --no-cache-dir Cython && pip install --no-cache-dir pycocotools
RUN cd /tmp && \
    git clone --recursive https://github.com/mlcommons/inference && \
    cd inference/loadgen && \
    pip install --no-cache-dir pybind11 && \
    CFLAGS="-std=c++14" python setup.py install && \
    rm -rf mlperf

ENTRYPOINT ["/bin/bash"]
