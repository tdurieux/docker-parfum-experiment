FROM tensorflow/tensorflow:1.9.0-gpu-py3

RUN pip --no-cache-dir install --upgrade \
        http://download.pytorch.org/whl/cu90/torch-0.4.0-cp35-cp35m-linux_x86_64.whl \
        torchvision==0.2.1 \
    && rm -rf /tmp/* \
    && rm -rf /root/.cache

RUN apt-get -y update
RUN pip install --no-cache-dir --upgrade pip

# Python Libraries
RUN pip install --no-cache-dir opencv-python==3.4.3.18
RUN apt-get -y --no-install-recommends install libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir h5py==2.8.0
RUN pip install --no-cache-dir tqdm==4.24.0
RUN pip install --no-cache-dir albumentations==0.1.2
RUN pip install --no-cache-dir keras==2.2.0

RUN apt-get -y --no-install-recommends install python3-tk && rm -rf /var/lib/apt/lists/*;

ENV PYTHONPATH $PYTHONPATH:/workdir
ENV TORCH_HOME=/workdir/data/.torch

WORKDIR /workdir
