FROM gemfield/deepvac:11.0.3-cudnn8-devel-ubuntu20.04
LABEL maintainer "Gemfield <gemfield@civilnet.cn>"

WORKDIR /gemfield
ENV TORCH_CUDA_ARCH_LIST="6.1;7.0;7.5;8.0"
COPY vision /gemfield/vision

RUN cd vision && pip install --no-cache-dir -v .

#docker build -t gemfield/deepvac:vision-11.0.3-cudnn8-devel-ubuntu20.04 -f libdeepvac/docker/ubuntu20.04/Dockerfile.deepvac.vision .
