FROM pytorch/pytorch:1.3-cuda10.1-cudnn7-devel

ENV LANG=C.UTF-8
WORKDIR /workspace/
COPY ./ /workspace/

# install basics
RUN apt-get update -y && apt-get install --no-install-recommends -y git curl htop wget tmux && rm -rf /var/lib/apt/lists/*;

# install python deps
RUN pip install --no-cache-dir -r /workspace/requirements.txt
