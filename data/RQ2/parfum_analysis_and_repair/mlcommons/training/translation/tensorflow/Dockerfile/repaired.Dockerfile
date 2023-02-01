FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04
WORKDIR /research
RUN apt-get update
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    git \
    python \
    python-pip && rm -rf /var/lib/apt/lists/*;
ENV HOME /research
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN apt-get install --no-install-recommends -y python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip python3-pip virtualenv htop && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade numpy scipy sklearn tensorflow-gpu==1.9.0

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Mount data into the docker
ADD . /research/transformer
WORKDIR /research/transformer
RUN pip3 install --no-cache-dir -r requirements.txt
ENTRYPOINT ["/bin/bash"]

