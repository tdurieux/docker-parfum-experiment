ARG PYTORCH="1.8.1"
ARG CUDA="10.2"
ARG CUDNN="7"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV CMAKE_PREFIX_PATH="(dirname(which conda))/../"

RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install MMCV
RUN pip install --no-cache-dir openmim
RUN mim install mmcv-full

# Install MMClassification
RUN conda clean --all
RUN git clone https://github.com/open-mmlab/mmclassification.git
WORKDIR ./mmclassification
RUN pip install --no-cache-dir -e .
