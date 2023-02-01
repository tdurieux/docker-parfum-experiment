FROM pytorch/pytorch:1.8.1-cuda11.1-cudnn8-devel

# Labels for the docker
LABEL description="Archai docker with pytorch 1.8.1 cuda11.1 cudnn 8 devel" \
      repository="pytorch:1.8.1-cuda11.1-cudnn8-devel" \
      tag="latest" \
      creator="dedey" tooltype="pytorch" \
      tooltypeversion="1.8.1" \
      createtime="06/22/2021"

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --user tensorboard

# Apex
RUN git clone https://github.com/NVIDIA/apex
RUN ls -l
RUN pwd
WORKDIR "/workspace/apex"
RUN pip install --user -v --disable-pip-version-check --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
WORKDIR "/workspace"

