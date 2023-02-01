# https://hub.docker.com/r/mapler/pytorch-cpu/dockerfile

FROM ubuntu:16.04
LABEL maintainer="nlkey2022@gmail.com"

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         git \
         curl \
         ca-certificates \
         libjpeg-dev \
         libpng-dev && \
     rm -rf /var/lib/apt/lists/*

RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda install conda-build && \
     /opt/conda/bin/conda create -y --name pytorch-py35 python=3.5.2 numpy boto3 flask requests pyyaml scipy ipython mkl&& \
     /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/envs/pytorch-py35/bin:$PATH
#RUN conda install --name pytorch-py35 -c soumith magma-cuda80 && /opt/conda/bin/conda clean -ya
RUN conda install --name pytorch-py35 pytorch torchvision -c soumith && /opt/conda/bin/conda clean -ya

COPY master.py /tmp/master.py
RUN pip install -U protobuf tensorflow
RUN pip install -U tensorboardX
ENTRYPOINT ["python3", "/tmp/master.py"]
