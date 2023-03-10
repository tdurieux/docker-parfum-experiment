ARG CUDA_VERSION=${CUDA_VERSION:-"10.2"}
ARG UBUNTU_VERSION=${UBUNTU_VERSION:-"18.04"}

FROM nvidia/cuda:${CUDA_VERSION}-cudnn7-devel-ubuntu${UBUNTU_VERSION}

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo \
    build-essential \
    curl \
    libcurl4-openssl-dev \
    libssl-dev \
    wget \
    python3-dev \
    python3-pip \
    libxrender-dev \
    libxext6 \
    libsm6 \
    openssl \
    nano \
    bash \
    git && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/service
COPY requirements.txt .

RUN pip3 install --no-cache-dir --upgrade pip && \
	pip3 install --no-cache-dir -r requirements-service.txt

RUN python3 -c 'import torch; print(torch.cuda.is_available())'

COPY api.py /opt/service

ENTRYPOINT ["python3", "./api.py"]
