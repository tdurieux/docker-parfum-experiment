FROM pytorch/pytorch:1.0.1-cuda10.0-cudnn7-runtime

ENV LC_ALL en_US.UTF-8

ENV LANG en_US.UTF-8

ENV LANGUAGE en_US.UTF-8

# Use bash as default shell, rather than sh

ENV SHELL /bin/bash

WORKDIR /code

RUN apt-get update && apt-get -y --no-install-recommends -qq install libglib2.0-0 libsm6 libxext6 libfontconfig1 libxrender1 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir torchvision

RUN pip install --no-cache-dir -U polyaxon-client==0.4.1

RUN pip install --no-cache-dir polyaxon-client[gcs]

RUN pip install --no-cache-dir opencv-python

RUN pip install --no-cache-dir tqdm

RUN pip install --no-cache-dir pandas

RUN pip install --no-cache-dir scikit-learn

RUN pip install --no-cache-dir rasterio

RUN pip install --no-cache-dir scipy

RUN pip install --no-cache-dir scikit-image

RUN pip install --no-cache-dir comet_ml

RUN  pip install --no-cache-dir -U polyaxon-helper

RUN  pip install --no-cache-dir -U polyaxon-gpustat

COPY build /code
