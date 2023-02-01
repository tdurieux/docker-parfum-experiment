# Use nvidia/cuda image
FROM nvidia/cuda:11.3.0-cudnn8-devel-ubuntu20.04
CMD nvidia-smi

# Ignore interactive questions during `docker build`
ENV DEBIAN_FRONTEND noninteractive

# Bash shell
RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-c"]

# Temporary fix until NVDIA finish the update of its docker images
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;

# Install and update tools to minimize security vulnerabilities
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common wget apt-utils patchelf git libprotobuf-dev protobuf-compiler cmake \
    bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 mercurial subversion libopenmpi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN unattended-upgrade
RUN apt-get autoremove -y

# Install Pythyon (3.8 as default)
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
RUN pip install --no-cache-dir --upgrade pip

# Install onnxruntime-training dependencies
# This version doesn't support training gpt2 with fp16
RUN pip install --no-cache-dir onnx==1.11.0 ninja
RUN pip install --no-cache-dir torch==1.11.0+cu113 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install --no-cache-dir onnxruntime-training==1.11.1+cu113 -f https://download.onnxruntime.ai/onnxruntime_stable_cu113.html
RUN pip install --no-cache-dir torch-ort
# RUN python -m torch_ort.configure

WORKDIR .

CMD ["/bin/bash"]