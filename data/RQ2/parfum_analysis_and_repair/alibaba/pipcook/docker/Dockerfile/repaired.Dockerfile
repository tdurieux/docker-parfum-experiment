FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu18.04
ARG VER=latest

LABEL version=${VER}
LABEL description="docker image for pipcook runtime"

ENV TF_FORCE_GPU_ALLOW_GROWTH=true

WORKDIR /root/
RUN apt-get update && apt-get install --no-install-recommends -y curl wget python git libglib2.0-0 libsm6 libxrender-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install @pipcook/cli@${VER} -g --unsafe-perm && npm cache clean --force;
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda-11.2/targets/x86_64-linux/lib/
