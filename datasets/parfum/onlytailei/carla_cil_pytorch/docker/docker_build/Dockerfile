FROM pytorch/pytorch:1.0-cuda10.0-cudnn7-runtime

RUN conda install -y -c conda-forge opencv
RUN conda clean -y -p -s
RUN pip install tensorboardX imgaug h5py
RUN apt-get update
RUN apt-get -y install libgl1-mesa-glx


RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*

WORKDIR /home
