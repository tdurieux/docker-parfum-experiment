ARG PYTORCH="1.10.0"
ARG CUDA="11.3"
ARG CUDNN="8"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 8.0 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"

RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install MMCV MMDetection MMSegmentation
RUN pip install --no-cache-dir mmcv-full==1.3.16 -f https://download.openmmlab.com/mmcv/dist/cu113/torch1.10.0/index.html
RUN pip install --no-cache-dir mmsegmentation mmdet
# Install MMSelfSup
RUN conda clean --all
RUN git clone https://github.com/open-mmlab/mmselfsup.git  /mmselfsup
WORKDIR /mmselfsup
ENV FORCE_CUDA="1"
RUN pip install --no-cache-dir -e .
