## need newest nvidia driver
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
ENV DEBIAN_FRONTEND noninteractive
ARG PYTHON_VERSION=3.6
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates libjpeg-dev libpng-dev python3-pip python3-setuptools \
    python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libglib2.0-0 cmake git unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip wheel setuptools
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

# docker build -t isic2018 .
# docker run --gpus all --rm -v $(pwd):/home/ISIC2018/ --user $(id -u):$(id -g) --name isic2018 --ipc=host -it isic2018  bash
# python3 -c "import torch; print(torch.cuda.is_available())"
# nvcc --versionn