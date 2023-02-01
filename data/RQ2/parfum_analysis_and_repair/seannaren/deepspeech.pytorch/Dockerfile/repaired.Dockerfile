FROM nvcr.io/nvidia/pytorch:22.03-py3
ENV DEBIAN_FRONTEND=noninteractive

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

WORKDIR /workspace/

# install basics
RUN apt-get update -y && apt-get install --no-install-recommends -y git curl ca-certificates bzip2 cmake tree htop bmon iotop sox libsox-dev libsox-fmt-all vim && rm -rf /var/lib/apt/lists/*;

# install ctcdecode
RUN git clone --recursive https://github.com/parlance/ctcdecode.git
RUN cd ctcdecode; pip install --no-cache-dir .

# install deepspeech.pytorch
ADD . /workspace/deepspeech.pytorch
RUN cd deepspeech.pytorch; pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir -e .

# launch jupyter
WORKDIR /workspace/deepspeech.pytorch
RUN mkdir data; mkdir notebooks;
CMD jupyter-notebook --ip="*" --no-browser --allow-root
