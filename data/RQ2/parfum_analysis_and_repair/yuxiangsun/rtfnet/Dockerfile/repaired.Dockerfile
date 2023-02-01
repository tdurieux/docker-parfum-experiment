FROM nvidia/cuda:11.3.3-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes

RUN apt-get update && apt-get install --no-install-recommends -y vim python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U scipy scikit-learn
RUN pip3 install --no-cache-dir install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
RUN pip3 install --no-cache-dir tensorboard torchsummary==1.5.1
