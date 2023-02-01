ARG FROM_IMAGE_NAME=nvcr.io/nvidia/tensorflow:20.12-tf1-py3
FROM ${FROM_IMAGE_NAME}

ENV PYTHONPATH /workspace/rn50v15_tf
WORKDIR /workspace/rn50v15_tf

ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ADD . .
