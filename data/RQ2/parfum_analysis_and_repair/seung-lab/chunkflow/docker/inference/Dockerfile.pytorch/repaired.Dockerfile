#FROM pytorch/pytorch:0.4_cuda9_cudnn7
#FROM pytorch/pytorch:0.4.1-cuda9-cudnn7-runtime
#FROM pytorch/pytorch:1.0-cuda10.0-cudnn7-runtime
FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-runtime
#FROM gcr.io/tpu-pytorch/xla:r0.5

ENV HOME /root

# make pip3 command available
RUN apt update && \
    apt install -y -qq --no-install-recommends \ 
        python3-dev \
        python3-pip && rm -rf /var/lib/apt/lists/*;

# ln -s /opt/conda/bin/pip /usr/bin/pip3

COPY pytorch-emvision $HOME/workspace/chunkflow/docker/inference/pytorch-emvision/
COPY pytorch-model $HOME/workspace/chunkflow/docker/inference/pytorch-model/

RUN echo "export PYTHONPATH=$HOME/workspace/chunkflow/docker/inference/pytorch-model:$HOME/workspace/chunkflow/docker/inference/pytorch-emvision:\$PYTHONPATH" >> $HOME/.bashrc;
