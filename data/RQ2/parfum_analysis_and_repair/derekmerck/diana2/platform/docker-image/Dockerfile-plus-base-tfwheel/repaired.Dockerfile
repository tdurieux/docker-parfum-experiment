# xArch Diana-Plus Base Image
# Derek Merck, Winter 2019

ARG DOCKER_ARCH="amd64"
# ARG DOCKER_ARCH="arm32v7"
# ARG DOCKER_ARCH="arm64v8"

FROM derekmerck/diana2-base:latest-${DOCKER_ARCH}

LABEL description="X-Arch Diana-Plus Base"

RUN apt -y update && DEBIAN_FRONTEND=noninteractive apt -y install --no-install-recommends \
    python3-cffi \
    python3-grpcio \
    python3-h5py \
    python3-protobuf \
    python3-numpy-dev \
    python3-opencv \
    python3-pydot \
    python3-scipy \
    python3-sklearn \
    cython3 \
    libhdf5-dev \
    libatlas-base-dev \
    libopenblas-dev \
    gfortran \
   && apt clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-deps --no-cache-dir -U \
    parameterized \
    absl-py \
    pyparsing

COPY *.whl /tmp/
RUN pip3 install --no-cache-dir -U /tmp/${TF_WHEEL} && rm /tmp/${TF_WHEEL}

ENV KERAS_BACKEND=tensorflow
RUN pip3 install --no-cache-dir -U keras
