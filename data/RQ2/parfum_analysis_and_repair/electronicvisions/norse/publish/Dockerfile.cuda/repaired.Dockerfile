FROM nvidia/cuda:11.4.1-cudnn8-runtime-ubuntu20.04

RUN apt update && apt install --no-install-recommends -y python3-pip build-essential && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/

WORKDIR /norse

COPY . .

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir torch==1.9.1+cu111 torchvision==0.10.1+cu111 torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip3 install --no-cache-dir -e .