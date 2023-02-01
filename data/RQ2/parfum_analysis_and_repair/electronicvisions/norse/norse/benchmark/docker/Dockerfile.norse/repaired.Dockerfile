FROM nvidia/cuda:11.4.2-devel-ubuntu20.04

RUN apt update && apt install --no-install-recommends -y \
    git python3-pip && rm -rf /var/lib/apt/lists/*;

# Install norse
RUN pip install --no-cache-dir pandas
RUN pip install --no-cache-dir git+https://github.com/norse/norse

# Install correct version of torch
RUN pip3 install --no-cache-dir torch==1.9.1+cu111 torchvision==0.10.1+cu111 torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html