ARG FROM_IMAGE_NAME=nvcr.io/nvidia/tensorflow:21.02-tf2-py3
FROM ${FROM_IMAGE_NAME}

ADD . /workspace/unet
WORKDIR /workspace/unet

RUN pip install --no-cache-dir git+https://github.com/NVIDIA/dllogger
RUN pip install --no-cache-dir -r requirements.txt
