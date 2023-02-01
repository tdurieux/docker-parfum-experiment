FROM continuumio/miniconda:latest

RUN conda config --set always_yes yes
RUN conda install python=3.7

RUN conda install pytorch torchvision cudatoolkit=10.1 -c pytorch
RUN conda install -c menpo opencv
RUN pip install --no-cache-dir tensorboardX scikit-image tqdm pyyaml easydict future

COPY ./ /ZS3
RUN pip install --no-cache-dir -e /ZS3

WORKDIR /ZS3/zs3
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
