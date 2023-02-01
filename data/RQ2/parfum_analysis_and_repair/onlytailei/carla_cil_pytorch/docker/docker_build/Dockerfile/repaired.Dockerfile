FROM pytorch/pytorch:1.0-cuda10.0-cudnn7-runtime

RUN conda install -y -c conda-forge opencv
RUN conda clean -y -p -s
RUN pip install --no-cache-dir tensorboardX imgaug h5py
RUN apt-get update && apt-get -y --no-install-recommends install libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;


RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*

WORKDIR /home
