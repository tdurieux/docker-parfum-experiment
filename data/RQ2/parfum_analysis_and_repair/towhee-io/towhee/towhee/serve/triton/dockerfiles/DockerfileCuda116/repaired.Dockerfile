FROM nvcr.io/nvidia/tritonserver:22.04-py3

ARG MODEL_FORMAT_PRIORITY

RUN apt-key adv --fetch-keys \
    https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub && \
    apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
              zip \
              wget \
              unzip \
              python3.8 \
              python3-pip \
              libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -U pip

RUN pip3 install --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116

RUN pip3 install --no-cache-dir pyarrow onnxruntime

RUN pip3 install --no-cache-dir towhee towhee.models

RUN apt-get install -y --no-install-recommends git-lfs && \
    git lfs install && rm -rf /var/lib/apt/lists/*;

WORKDIR /workspace

RUN mkdir -p /workspace/models

COPY ./dag.json /workspace/dag.json

RUN triton_builder /workspace/dag.json /workspace/models ${MODEL_FORMAT_PRIORITY}

