FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
LABEL maintainer "Takuya Takeuchi <takuya.takeuchi.dev@gmail.com>"

# install package to build
RUN apt-get update && apt-get install --no-install-recommends -y \
    libopenblas-dev \
    liblapack-dev \
    libx11-6 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*