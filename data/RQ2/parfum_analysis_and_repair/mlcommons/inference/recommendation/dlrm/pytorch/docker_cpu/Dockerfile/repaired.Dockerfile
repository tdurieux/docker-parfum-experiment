FROM ubuntu:18.04

ENV PYTHON_VERSION=3.8
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
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh -O miniconda.sh && \
    /bin/bash ./miniconda.sh -b -p /opt/anaconda3 && \
    rm miniconda.sh && \
    /opt/anaconda3/bin/conda clean -tipsy && \
    ln -s /opt/anaconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/anaconda3/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    conda config --set always_yes yes --set changeps1 no

RUN conda install pytorch torchvision cpuonly -c pytorch
RUN pip install --no-cache-dir future pillow onnx opencv-python-headless tensorflow==2.4 onnxruntime
RUN pip install --no-cache-dir tensorboard
RUN pip install --no-cache-dir Cython && pip install --no-cache-dir pycocotools
RUN pip install --no-cache-dir scikit-learn
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir pydot
RUN pip install --no-cache-dir torchviz
RUN pip install --no-cache-dir protobuf
RUN pip install --no-cache-dir tqdm
RUN pip install --no-cache-dir pybind11

RUN cd /tmp && \
    git clone --recurse-submodules https://github.com/mlcommons/inference && \
    cd inference/loadgen && \
    CFLAGS="-std=c++14" python setup.py install && \
    cd ../../ && \
    rm -rf inference


ENTRYPOINT ["/bin/bash"]
